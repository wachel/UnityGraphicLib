using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VirtualTexture
{

    public class VirtualTextureTerrainRenderer : MonoBehaviour
    {
        Material previewMat;                //调试用
        Material previewMat2;               //调试用
        Material rendererMat;               //调试用
        Material matDebug;
        public RenderTexture indirectiveTexture;   
        public RenderTexture physicsTexture;
        public RenderTexture physicsNormal;

        public bool useNormalMap = true;
        public int quadTreeSize = 256;      //设置细分程度
        public int physicsSize = 2048;      //物理纹理大小
        public int physicsTileSize = 128;   //物理纹理每块大小
        public bool debug;

        QuadTree qt;
        PhysicsTileManager tileManager;

        Terrain terrain;
        int indirectiveTextureSize;
        Material updatePhysicsMaterial;
        Material updateIndirectiveMaterial;
        Texture2D nullTexture;
        Texture2D defaultNormal;
        List<UpdateIndirectiveCommand> nodesToUpdate = new List<UpdateIndirectiveCommand>();
        List<UpdatePhysicalTextureCommand> updatePhysicsCommandClearList = new List<UpdatePhysicalTextureCommand>();
        List<UpdatePhysicalTextureCommand> updatePhysicsCommandDrawList = new List<UpdatePhysicalTextureCommand>();

        Terrain.MaterialType defaultMaterialType;

        public void Awake()
        {
            terrain = GetComponent<Terrain>();
            defaultMaterialType = terrain.materialType;
        }

        void Start()
        {
            tileManager = new PhysicsTileManager();
            tileManager.Init(physicsSize, physicsTileSize);
            qt = new QuadTree();
            qt.Init(quadTreeSize);
            qt.funPostSplit = OnPostSplitNode;
            qt.funPrevMerge = OnPrevMergeNode;
            qt.funPrevSplit = OnPrevSplitNode;
            qt.funPostMerge = OnPostMergeNode;

            physicsTexture = new RenderTexture(physicsSize, physicsSize, 0, RenderTextureFormat.ARGB32);
            if (useNormalMap) {
                physicsNormal = new RenderTexture(physicsSize, physicsSize, 0, RenderTextureFormat.ARGB32);
            }
            updatePhysicsMaterial = new Material(Shader.Find("Hidden/VTBakeBaseTexture"));
            nullTexture = new Texture2D(1, 1);
            defaultNormal = new Texture2D(1, 1);
            defaultNormal.SetPixel(0, 0, new Color(0.5f, 0.5f, 1));
            defaultNormal.Apply();

            indirectiveTextureSize = quadTreeSize;
            indirectiveTexture = new RenderTexture(indirectiveTextureSize, indirectiveTextureSize, 0, RenderTextureFormat.ARGB32);
            indirectiveTexture.filterMode = FilterMode.Point;
            indirectiveTexture.useMipMap = false;
            updateIndirectiveMaterial = new Material(Shader.Find("Hidden/VTUpdateIndirectiveTexture"));

            if (previewMat) {
                previewMat.mainTexture = physicsTexture;
            }
            if (previewMat2) {
                previewMat2.mainTexture = indirectiveTexture;
            }
            if (rendererMat) {
                rendererMat.SetTexture("_IndirectiveTex", indirectiveTexture);
                rendererMat.SetTexture("_PhysicalTex", physicsTexture);
                rendererMat.SetFloat("_TileSize", physicsTileSize / (float)physicsSize);
            }
            SetTerrainMaterial();
        }

        void SetTerrainMaterial()
        {
            terrain.materialType = Terrain.MaterialType.Custom;
            if (defaultMaterialType == Terrain.MaterialType.BuiltInStandard) {
                terrain.materialTemplate = new Material(Shader.Find("Nature/Terrain/VTStandard"));
            } else {
                terrain.materialTemplate = new Material(Shader.Find("Nature/Terrain/VTDiffuse"));
            }
            terrain.materialTemplate.SetTexture("_IndirectiveTex", indirectiveTexture);
            terrain.materialTemplate.SetTexture("_PhysicalTex", physicsTexture);
            terrain.materialTemplate.SetTexture("_PhysicalNormal", physicsNormal);
            terrain.materialTemplate.SetFloat("_TileSize", physicsTileSize / (float)physicsSize);
        }

        public void OnEnable()
        {
            SetTerrainMaterial();
        }

        public void OnDisable()
        {
            terrain.materialType = defaultMaterialType;
        }

        public void OnGUI()
        {
            if (debug) {
                if (matDebug == null) {
                    matDebug = new Material(Shader.Find("Hidden/VTDebug"));
                }
                if (matDebug) {
                    Graphics.DrawTexture(new Rect(0, 0, 128, 128), indirectiveTexture, matDebug, 0);
                    Graphics.DrawTexture(new Rect(128, 0, 128, 128), physicsTexture, matDebug, 1);
                    Graphics.DrawTexture(new Rect(256, 0, 128, 128), physicsNormal, matDebug, 1);
                }
            }
        }

        void OnPrevSplitNode(QtNode node)
        {

        }

        void OnPostSplitNode(QtNode node)
        {
            if (node.tile != null) {
                PhysicsTile tile = node.tile;
                //ClearPhysicsTexture(tile);
                updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile,physicsSize,null,0));
                UpdatePhysicsTexture();
                tileManager.Recyle(tile);
                node.tile = null;
            }
            for (int i = 0; i < 4; i++) {
                PhysicsTile tile = tileManager.GetAnyUnusedTile();
                if (tile != null) {
                    node.children[i].tile = tile;
                    //DrawPhysicsTexture(tile, node.children[i]);
                    updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile, physicsSize, node.children[i], quadTreeSize));
                    UpdatePhysicsTexture();
                    nodesToUpdate.Add(new UpdateIndirectiveCommand(node.children[i]));
                }
            }
        }

        void OnPrevMergeNode(QtNode node)
        {
            for (int i = 0; i < 4; i++) {
                if (node.children[i].tile != null) {
                    PhysicsTile tile = node.children[i].tile;
                    //ClearPhysicsTexture(tile);
                    updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile, physicsSize, null, 0));
                    UpdatePhysicsTexture();
                    tileManager.Recyle(tile);
                }
            }

        }

        void OnPostMergeNode(QtNode node)
        {
            PhysicsTile tile = tileManager.GetAnyUnusedTile();
            if (tile != null) {
                node.tile = tile;
                //DrawPhysicsTexture(tile, node);
                updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile, physicsSize, node, quadTreeSize));
                UpdatePhysicsTexture();
                nodesToUpdate.Add(new UpdateIndirectiveCommand(node));
            }
        }

        //void DrawPhysicsTexture(PhysicsTile tile, QtNode node)
        //{
        //    Rect rect = new Rect(tile.uv.x * physicsSize, tile.uv.y * physicsSize, tile.size * physicsSize, tile.size * physicsSize);
        //    //Graphics.DrawTexture(rect, nullTexture, updatePhysicsMaterial, 0);
        //
        //    Material mat = updatePhysicsMaterial;
        //    TerrainData terrainData = terrain.terrainData;
        //    ClearPhysicsTexture(tile);
        //    for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
        //        mat.SetTexture("_MainTex", terrainData.splatPrototypes[layer].texture);
        //        Vector2 tileSize = terrainData.splatPrototypes[layer].tileSize;
        //        mat.mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
        //        mat.mainTextureOffset = terrainData.splatPrototypes[layer].tileOffset;
        //        mat.SetVector("_MainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
        //        mat.SetTexture("_SplatAlpha", terrainData.alphamapTextures[layer / 4]);
        //        mat.SetFloat("_SplatIndex", layer % 4);
        //        float bd = node.size * (4 / (tile.size * physicsSize));//border
        //        mat.SetVector("_SrcRectST", new Vector4(node.size + bd * 2, node.size + bd * 2, node.x - bd, node.y - bd) / quadTreeSize);
        //        Graphics.DrawTexture(rect, mat.mainTexture, mat, 1);
        //    }
        //}
        //
        //void ClearPhysicsTexture(PhysicsTile tile)
        //{
        //    Rect rect = new Rect(tile.uv.x * physicsSize, tile.uv.y * physicsSize, tile.size * physicsSize, tile.size * physicsSize);
        //    Graphics.DrawTexture(rect, nullTexture, updatePhysicsMaterial, 0);
        //}

        void UpdateIndirectiveTexture()
        {
            RenderTexture.active = indirectiveTexture;
            GL.LoadPixelMatrix(0, quadTreeSize, 0, quadTreeSize);

            for (int i = 0; i < nodesToUpdate.Count; i++) {
                UpdateIndirectiveCommand cmd = nodesToUpdate[i];
                Rect rect = new Rect(cmd.nodeX, cmd.nodeY, cmd.nodeSize, cmd.nodeSize);
                Color color = new Color(cmd.tx / 255.0f, cmd.ty / 255.0f, Mathf.Log(cmd.nodeSize, 2) / 255.0f, 1);
                updateIndirectiveMaterial.SetColor("_Color", color);
                Graphics.DrawTexture(rect, nullTexture, updateIndirectiveMaterial);
            }
            nodesToUpdate.Clear();
        }

        void UpdatePhysicsTexture(bool normal)
        {
            RenderTexture.active = normal?physicsNormal: physicsTexture;
            GL.LoadPixelMatrix(0, physicsSize, 0, physicsSize);

            for(int i =0; i<updatePhysicsCommandDrawList.Count; i++) {
                UpdatePhysicalTextureCommand cmd = updatePhysicsCommandDrawList[i];
                Graphics.DrawTexture(cmd.dest, nullTexture, updatePhysicsMaterial, 0);//clear
                if(cmd.src!= null) {
                    Material mat = updatePhysicsMaterial;
                    TerrainData terrainData = terrain.terrainData;
                    Graphics.DrawTexture(cmd.dest, nullTexture, updatePhysicsMaterial, 0);//clear
                    for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
                        mat.mainTexture = terrainData.splatPrototypes[layer].texture;
                        mat.SetTexture("_PhysicalNormal", terrainData.splatPrototypes[layer].normalMap);
                        Vector2 tileSize = terrainData.splatPrototypes[layer].tileSize;
                        mat.mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
                        mat.mainTextureOffset = terrainData.splatPrototypes[layer].tileOffset;
                        mat.SetVector("_MainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
                        mat.SetTexture("_SplatAlpha", terrainData.alphamapTextures[layer / 4]);
                        mat.SetFloat("_SplatIndex", layer % 4);
                        mat.SetVector("_SrcRectST", cmd.src);
                        Graphics.DrawTexture(cmd.dest, mat.mainTexture, mat, normal ? 2 : 1);
                    }
                }
            }
        }

        void UpdatePhysicsTexture()
        {
            UpdatePhysicsTexture(false);
            UpdatePhysicsTexture(true);
            updatePhysicsCommandDrawList.Clear();
        }

        void Update()
        {

            GL.PushMatrix();

            Vector3 camPos = terrain.transform.InverseTransformPoint(Camera.main.transform.position);
            qt.Update(new Vector2(camPos.x, camPos.z) * quadTreeSize / terrain.terrainData.size.x);

            UpdatePhysicsTexture();
            UpdateIndirectiveTexture();

            RenderTexture.active = null;
            GL.PopMatrix();

            //DrawNode(qt.root);
        }

        void DrawNode(QtNode node)
        {
            Debug.DrawLine(new Vector3(node.x, 0, node.y), new Vector3(node.x + node.size, 0, node.y));
            Debug.DrawLine(new Vector3(node.x, 0, node.y), new Vector3(node.x, 0, node.y + node.size));
            Debug.DrawLine(new Vector3(node.x + node.size, 0, node.y), new Vector3(node.x + node.size, 0, node.y + node.size));
            Debug.DrawLine(new Vector3(node.x, 0, node.y + node.size), new Vector3(node.x + node.size, 0, node.y + node.size));
            if (node.children != null) {
                for (int i = 0; i < 4; i++) {
                    DrawNode(node.children[i]);
                }
            }
        }


    }
    public class UpdateIndirectiveCommand
    {
        public UpdateIndirectiveCommand(QtNode node)
        {
            nodeX = node.x; nodeY = node.y;
            nodeSize = node.size;
            tx = node.tile.x;
            ty = node.tile.y;
        }
        public int nodeX;//四叉树的节点位置x
        public int nodeY;//四叉树节点y
        public int nodeSize;//四叉树节点的大小

        public int tx;//物理纹理的tile的坐标x
        public int ty;//物理纹理的tile坐标y
    }

    public class UpdatePhysicalTextureCommand
    {
        public UpdatePhysicalTextureCommand(PhysicsTile tile, int physicsSize, QtNode node, int quadTreeSize)
        {
            dest = new Rect(tile.uv.x * physicsSize, tile.uv.y * physicsSize, tile.size * physicsSize, tile.size * physicsSize);
            if (node != null) {
                float bd = node.size * (4 / (tile.size * physicsSize));//border
                src = new Vector4(node.size + bd * 2, node.size + bd * 2, node.x - bd, node.y - bd) / quadTreeSize;
            }
        }
        public Vector4 src;//源：地图上的位置
        public Rect dest;//目标：物理纹理上的位置
    }

    public class QtNode
    {
        public int x;
        public int y;
        public int size;
        public PhysicsTile tile;
        public QtNode[] children = null;
        public QtNode(int x, int y, int size)
        {
            this.x = x;
            this.y = y;
            this.size = size;
        }
        public void Split()
        {
            children = new QtNode[4];
            int half = size / 2;
            children[0] = new QtNode(x, y, half);
            children[1] = new QtNode(x + half, y, half);
            children[2] = new QtNode(x, y + half, half);
            children[3] = new QtNode(x + half, y + half, half);
        }
        public void Merge()
        {
            children = null;
        }
        public Vector2 Center { get { return new Vector2(x + size / 2, y + size / 2); } }
    }

    public class QuadTree
    {
        public QtNode root = null;
        public System.Action<QtNode> funPrevSplit;
        public System.Action<QtNode> funPostSplit;
        public System.Action<QtNode> funPrevMerge;
        public System.Action<QtNode> funPostMerge;
        public void Init(int size)
        {
            root = new QtNode(0, 0, size);
        }
        public void Update(Vector2 camPos)
        {
            UpdateMerge(root, camPos);
            UpdateSplit(root, camPos);
        }

        bool needSplit(QtNode node, Vector2 camPos)
        {
            float length = (node.Center - camPos).magnitude;
            return length < node.size * 1.8f && node.size > 1;
        }

        void UpdateMerge(QtNode node, Vector2 camPos)
        {
            if (!needSplit(node,camPos)) {
                if (node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateMerge(node.children[i], camPos);
                    }
                    funPrevMerge(node);
                    node.Merge();
                    funPostMerge(node);
                }
            } else {
                if(node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateMerge(node.children[i], camPos);
                    }
                }
            }
        }

        void UpdateSplit(QtNode node, Vector2 camPos)
        {
            if (needSplit(node, camPos)) {
                if (node.children == null) {
                    funPrevSplit(node);
                    node.Split();
                    funPostSplit(node);
                }
                if (node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateSplit(node.children[i], camPos);
                    }
                }
            } 
        }
    }

    public class PhysicsTile
    {
        public PhysicsTile(int x, int y, float u, float v, float size)
        {
            this.x = x; this.y = y;
            uv = new Vector2(u, v);
            this.size = size;
        }
        public int x, y;
        public Vector2 uv;
        public float size;
    }

    public class PhysicsTileManager
    {
        public List<PhysicsTile> unusedTiles = new List<PhysicsTile>();
        public void Init(int size, int tileSize)
        {
            int numX = size / tileSize;
            for (int i = 0; i < numX; i++) {
                for (int j = 0; j < numX; j++) {
                    unusedTiles.Add(new PhysicsTile(i, j, i * tileSize / (float)size, j * tileSize / (float)size, tileSize / (float)size));
                }
            }
        }
        public PhysicsTile GetAnyUnusedTile()
        {
            if (unusedTiles.Count > 0) {
                PhysicsTile rlt = unusedTiles[0];
                unusedTiles.RemoveAt(0);
                return rlt;
            }
            return null;
        }
        public void Recyle(PhysicsTile tile)
        {
            unusedTiles.Add(tile);
        }
    }
}


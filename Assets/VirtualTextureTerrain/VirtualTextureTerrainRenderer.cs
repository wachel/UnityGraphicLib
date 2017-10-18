using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace VirtualTexture
{
    public class VirtualTextureTerrainRenderer : MonoBehaviour
    {
        Material matDebug;
        public RenderTexture indirectiveTexture;
        public Texture2D physicsTexture;
        public Texture2D physicsNormal;

        public RenderTexture tempPhysicsTexture;
        public RenderTexture tempPhysicsNormal;

        RenderTexture tempPhysicsTexture2;
        RenderTexture tempPhysicsNormal2;

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
        Material defaultMaterial;

        public void Awake()
        {
            terrain = GetComponent<Terrain>();
            defaultMaterialType = terrain.materialType;
            defaultMaterial = terrain.materialTemplate;

            tileManager = new PhysicsTileManager();
            tileManager.Init(physicsSize, physicsTileSize);
            qt = new QuadTree();
            qt.Init(quadTreeSize);
            qt.funNewNode = OnNewNode;
            qt.funDeleteNode = OnDeleteNode;

            physicsTexture = new Texture2D(physicsSize, physicsSize,  TextureFormat.ARGB32, false);
            if (useNormalMap) {
                physicsNormal = new Texture2D(physicsSize, physicsSize, TextureFormat.ARGB32,false);
            }
            tempPhysicsTexture = new RenderTexture(physicsTileSize, physicsTileSize, 0, RenderTextureFormat.ARGB32);
            tempPhysicsNormal = new RenderTexture(physicsTileSize, physicsTileSize, 0, RenderTextureFormat.ARGB32);

            tempPhysicsTexture2 = new RenderTexture(physicsTileSize * 4, physicsTileSize * 4, 0, RenderTextureFormat.ARGB32);
            tempPhysicsNormal2 = new RenderTexture(physicsTileSize * 4, physicsTileSize * 4, 0, RenderTextureFormat.ARGB32);

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
        }

        void Start()
        {
            SetTerrainMaterial();
        }

        void SetTerrainMaterial()
        {
            terrain.materialType = Terrain.MaterialType.Custom;
            if (defaultMaterialType == Terrain.MaterialType.BuiltInStandard) {
                terrain.materialTemplate = new Material(Shader.Find("Nature/Terrain/VTStandard"));
            } else {
                terrain.materialTemplate = new Material(Shader.Find("Unlit/M1VTTerrain"));
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
            terrain.materialTemplate = defaultMaterial;
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

        void OnNewNode(QtNode node)
        {
            PhysicsTile tile = tileManager.GetAnyUnusedTile();
            if (tile != null) {
                updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile, physicsSize, node, quadTreeSize));
                UpdatePhysicsTexture();
                node.tile = tile;
                nodesToUpdate.Add(new UpdateIndirectiveCommand(node,false));
            }
        }

        void OnDeleteNode(QtNode node)
        {
            PhysicsTile tile = node.tile;
            updatePhysicsCommandDrawList.Add(new UpdatePhysicalTextureCommand(tile, physicsSize, null, 0));//clear
            UpdatePhysicsTexture();
            tileManager.Recyle(tile);
            node.tile = null;
            nodesToUpdate.Add(new UpdateIndirectiveCommand(node, true));
        }

        void UpdateIndirectiveTexture()
        {
            
            RenderTexture.active = indirectiveTexture;
            GL.LoadPixelMatrix(0, quadTreeSize, 0, quadTreeSize);
            for (int i = 0; i < nodesToUpdate.Count; i++) {
                UpdateIndirectiveCommand cmd = nodesToUpdate[i];
                Rect rect = new Rect(cmd.nodeX, cmd.nodeY, cmd.nodeSize, cmd.nodeSize);
                Color color = cmd.clear?Color.black: new Color(cmd.tx / 255.0f, cmd.ty / 255.0f, Mathf.Log(cmd.nodeSize, 2) / 255.0f, 1);
                updateIndirectiveMaterial.SetColor("_Color", color);
                Graphics.DrawTexture(rect, nullTexture, updateIndirectiveMaterial);
            }
            nodesToUpdate.Clear();
        }

        bool HasAlpha(Texture2D texture)
        {
            return (texture.format == TextureFormat.Alpha8 
                || texture.format == TextureFormat.ARGB4444 
                || texture.format == TextureFormat.ARGB32 
                || texture.format == TextureFormat.DXT5 
                || texture.format == TextureFormat.PVRTC_RGBA2 
                || texture.format == TextureFormat.PVRTC_RGBA4 
                || texture.format == TextureFormat.ATC_RGBA8
                || texture.format == TextureFormat.ETC2_RGBA1
                || texture.format == TextureFormat.ETC2_RGBA8
                );
        }

        public bool disableDrawVT;
        public bool disableUpdateVT;

        void CopyToTexture() {
            for (int i = 0; i < updatePhysicsCommandDrawList.Count; i++) {
                UpdatePhysicalTextureCommand cmd = updatePhysicsCommandDrawList[i];
                if (cmd.rt != null) {
                    if (!disableUpdateVT) {
                        Graphics.CopyTexture(tempPhysicsTexture2, 0, 0, (int)cmd.tempRect.xMin, (int)cmd.tempRect.yMin, physicsTileSize, physicsTileSize, physicsTexture , 0, 0, (int)cmd.dest.xMin, (int)cmd.dest.yMin);
                        Graphics.CopyTexture(tempPhysicsNormal2, 0, 0, (int)cmd.tempRect.xMin, (int)cmd.tempRect.yMin, physicsTileSize, physicsTileSize, physicsNormal, 0, 0, (int)cmd.dest.xMin, (int)cmd.dest.yMin);
                    }
                }
            }
            updatePhysicsCommandDrawList.RemoveAll(item => item.rt != null);
        }

        void UpdatePhysicsTexture2(bool normal) {
            RenderTexture.active = normal ? tempPhysicsNormal2 : tempPhysicsTexture2;
            GL.LoadPixelMatrix(0, physicsTileSize * 4, 0, physicsTileSize * 4);
            RenderTexture.active.DiscardContents();
            for (int i = 0; i < updatePhysicsCommandDrawList.Count && i<16; i++) {
                Rect dest = new Rect((i % 4) * physicsSize, (i / 4) * physicsSize , physicsTileSize, physicsTileSize);

                UpdatePhysicalTextureCommand cmd = updatePhysicsCommandDrawList[i];
                cmd.rt = RenderTexture.active;
                Graphics.DrawTexture(dest, nullTexture, updatePhysicsMaterial, 0);//clear
                if (cmd.src != null) {
                    cmd.tempRect = dest;
                    Material mat = updatePhysicsMaterial;
                    TerrainData terrainData = terrain.terrainData;
                    if (!disableDrawVT) {
                        for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
                            mat.SetTexture("_VTMainTex" + layer, normal ? terrainData.splatPrototypes[layer].normalMap : terrainData.splatPrototypes[layer].texture);
                            bool hasAlpha = HasAlpha(terrainData.splatPrototypes[layer].texture);
                            mat.SetFloat("_VTSmoothness", hasAlpha ? 1 : terrainData.splatPrototypes[layer].smoothness);
                            if (layer % 4 == 0) {
                                mat.SetTexture("_VTSplatAlpha" + layer / 4, terrainData.alphamapTextures[layer / 4]);
                            }
                        }
                        Vector2 tileSize = terrainData.splatPrototypes[0].tileSize;
                        mat.mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
                        mat.mainTextureOffset = terrainData.splatPrototypes[0].tileOffset;
                        mat.SetVector("_VTMainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
                        mat.SetVector("_VTSrcRectST", cmd.src);
                        Graphics.DrawTexture(dest, Texture2D.whiteTexture, mat, normal ? 1 : 0);
                    }
                }
            }
        }

        //CommandBuffer cmdBuf;
        //void UpdatePhysicsTexture(bool normal) {
        //    if (cmdBuf != null) {
        //        Camera.main.RemoveCommandBuffer(CameraEvent.AfterEverything, cmdBuf);
        //    }
        //
        //    cmdBuf = new CommandBuffer();
        //    RenderTexture rt = normal ? tempPhysicsNormal : tempPhysicsTexture;
        //    cmdBuf.SetRenderTarget(rt);
        //    cmdBuf.SetViewport(new Rect(0, 0, physicsTileSize, physicsTileSize));
        //    //RenderTexture.active = normal ? tempPhysicsNormal : tempPhysicsTexture;
        //    //GL.LoadPixelMatrix(0, physicsTileSize, 0, physicsTileSize);
        //    //RenderTexture.active.DiscardContents();
        //    Rect dest = new Rect(0, 0, physicsTileSize, physicsTileSize);
        //
        //    for (int i = 0; i < updatePhysicsCommandDrawList.Count; i++) {
        //        cmdBuf.ClearRenderTarget(true, true, Color.black);
        //        UpdatePhysicalTextureCommand cmd = updatePhysicsCommandDrawList[i];
        //        //Graphics.DrawTexture(dest, nullTexture, updatePhysicsMaterial, 0);//clear
        //        cmdBuf.Blit(nullTexture, rt, updatePhysicsMaterial, 0);
        //        if (cmd.src != null) {
        //            Material mat = updatePhysicsMaterial;
        //            TerrainData terrainData = terrain.terrainData;
        //            if (!disableDrawVT) {
        //                for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
        //                    cmdBuf.SetGlobalTexture("_VTMainTex" + layer, normal ? terrainData.splatPrototypes[layer].normalMap : terrainData.splatPrototypes[layer].texture);
        //                    bool hasAlpha = HasAlpha(terrainData.splatPrototypes[layer].texture);
        //                    cmdBuf.SetGlobalFloat("_VTSmoothness", hasAlpha ? 1 : terrainData.splatPrototypes[layer].smoothness);
        //                    if (layer % 4 == 0) {
        //                        cmdBuf.SetGlobalTexture("_VTSplatAlpha" + layer / 4, terrainData.alphamapTextures[layer / 4]);
        //                    }
        //                }
        //                Vector2 tileSize = terrainData.splatPrototypes[0].tileSize;
        //                Vector2 mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
        //                Vector2 mainTextureOffset = terrainData.splatPrototypes[0].tileOffset;
        //                cmdBuf.SetGlobalVector("_VTMainTexST", new Vector4(mainTextureScale.x, mainTextureScale.y, mainTextureOffset.x, mainTextureOffset.y));
        //                cmdBuf.SetGlobalVector("_VTSrcRectST", cmd.src);
        //                cmdBuf.Blit(nullTexture, rt, mat,normal ? 1 : 0);
        //                //Graphics.DrawTexture(dest, Texture2D.whiteTexture, mat, normal ? 1 : 0);
        //            }
        //            if (!disableUpdateVT) {
        //                cmdBuf.CopyTexture(rt, 0,0, 0, 0, physicsTileSize, physicsTileSize, normal ? physicsNormal : physicsTexture, 0, 0, (int)cmd.dest.xMin, (int)cmd.dest.yMin);
        //                //Graphics.CopyTexture(RenderTexture.active, 0, 0, 0, 0, physicsTileSize, physicsTileSize, normal ? physicsNormal : physicsTexture, 0, 0, (int)cmd.dest.xMin, (int)cmd.dest.yMin);
        //            }
        //        }
        //    }
        //    //Camera.main.AddCommandBuffer(CameraEvent.AfterEverything, cmdBuf);
        //    Graphics.ExecuteCommandBuffer(cmdBuf);
        //}

        void UpdatePhysicsTexture(bool normal)
        {
            RenderTexture.active = normal ? tempPhysicsNormal : tempPhysicsTexture;
            GL.LoadPixelMatrix(0, physicsTileSize, 0, physicsTileSize);
            Rect dest = new Rect(0, 0, physicsTileSize, physicsTileSize);

            for (int i = 0; i < updatePhysicsCommandDrawList.Count; i++) {
                RenderTexture.active.DiscardContents();
                UpdatePhysicalTextureCommand cmd = updatePhysicsCommandDrawList[i];
                Graphics.DrawTexture(dest, nullTexture, updatePhysicsMaterial, 0);//clear
                if (cmd.src != null) {
                    Material mat = updatePhysicsMaterial;
                    TerrainData terrainData = terrain.terrainData;
                    if (!disableDrawVT) {
                        for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
                            mat.SetTexture("_VTMainTex" + layer, normal ? terrainData.splatPrototypes[layer].normalMap : terrainData.splatPrototypes[layer].texture);
                            bool hasAlpha = HasAlpha(terrainData.splatPrototypes[layer].texture);
                            mat.SetFloat("_VTSmoothness", hasAlpha ? 1 : terrainData.splatPrototypes[layer].smoothness);
                            if (layer % 4 == 0) {
                                mat.SetTexture("_VTSplatAlpha" + layer/4, terrainData.alphamapTextures[layer / 4]);
                            }
                        }
                        Vector2 tileSize = terrainData.splatPrototypes[0].tileSize;
                        mat.mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
                        mat.mainTextureOffset = terrainData.splatPrototypes[0].tileOffset;
                        mat.SetVector("_VTMainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
                        mat.SetVector("_VTSrcRectST", cmd.src);
                        Graphics.DrawTexture(dest, Texture2D.whiteTexture, mat, normal ? 1 : 0);
                    }
                    if (!disableUpdateVT) {
                        Graphics.CopyTexture(RenderTexture.active, 0, 0, 0, 0, physicsTileSize, physicsTileSize, normal ? physicsNormal : physicsTexture, 0, 0, (int)cmd.dest.xMin, (int)cmd.dest.yMin);
                    }
                }
            }
        }

        void UpdatePhysicsTexture()
        {
            //CopyToTexture();
            UpdatePhysicsTexture(false);
            UpdatePhysicsTexture(true);
            updatePhysicsCommandDrawList.Clear();
        }

        void Update()
        {

            GL.PushMatrix();

            Vector3 center = Camera.main.transform.position;
            if (CameraManager.Instance && CameraManager.Instance.controller.GetFollowTargetObject()) {
                center = CameraManager.Instance.controller.GetFollowTargetObject().transform.position;
            }

            Vector3 camPos = terrain.transform.InverseTransformPoint(center);
            qt.Update(new Vector2(camPos.x, camPos.z) * quadTreeSize / terrain.terrainData.size.x,70 * quadTreeSize / terrain.terrainData.size.x);

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
        public UpdateIndirectiveCommand(QtNode node,bool clear)
        {
            nodeX = node.x; nodeY = node.y;
            nodeSize = node.size;
            if (!clear) {
                tx = node.tile.x;
                ty = node.tile.y;
            }
            this.clear = clear;
        }
        public bool clear;

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
        public Rect tempRect;
        public Rect dest;//目标：物理纹理上的位置
        public RenderTexture rt;
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

        public System.Action<QtNode> funNewNode;
        public System.Action<QtNode> funDeleteNode;

        public void Init(int size)
        {
            root = new QtNode(0, 0, size);
        }
        public void Update(Vector2 camPos,float maxDistance)
        {
            UpdateMerge(root, camPos, maxDistance);
            UpdateSplit(root, camPos, maxDistance);
            UpdateRange(root, camPos, maxDistance);
        }

        bool NeedSplit(QtNode node, Vector2 camPos)
        {
            float length = (node.Center - camPos).magnitude;
            return length < node.size * 1.8f && node.size > 1;
        }

        bool InRange(QtNode node,Vector2 camPos,float maxDistance)
        {
            return true;
            float distance = (node.Center - camPos).magnitude - node.size * 0.5f * 1.5f;
            return distance < maxDistance;
        }

        void UpdateMerge(QtNode node, Vector2 camPos, float maxDistance)
        {
            if (!NeedSplit(node, camPos)) {
                if (node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateMerge(node.children[i], camPos, maxDistance);
                        if (node.children[i].tile != null) {
                            funDeleteNode(node.children[i]);
                        }
                    }
                    node.Merge();
                    if (InRange(node, camPos, maxDistance)) {
                        funNewNode(node);
                    }
                }
            } else {
                if (node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateMerge(node.children[i], camPos, maxDistance);
                    }
                }
            }
        }

        void UpdateSplit(QtNode node, Vector2 camPos, float maxDistance)
        {
            if (NeedSplit(node, camPos)) {
                if (node.children == null) {
                    if (node.tile != null) {
                        funDeleteNode(node);
                    }
                    node.Split();
                    for (int i = 0; i<4; i++) {
                        if(InRange(node.children[i], camPos, maxDistance)) {
                            funNewNode(node.children[i]);
                        }
                    }
                }
                if (node.children != null) {
                    for (int i = 0; i < 4; i++) {
                        UpdateSplit(node.children[i], camPos, maxDistance);
                    }
                }
            }
        }

        void UpdateRange(QtNode node,Vector2 camPos,float maxDistance)
        {
            if(node.children == null) {
                if(node.tile == null) {
                    if (InRange(node, camPos, maxDistance)) {
                        funNewNode(node);
                    }
                } else {
                    if (!InRange(node, camPos, maxDistance)) {
                        funDeleteNode(node);
                    }
                }
            } else {
                for (int i = 0; i < 4; i++) {
                    UpdateRange(node.children[i], camPos, maxDistance);
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


using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;



namespace TerrainConverter
{
    [System.Serializable]
    public class AlphaLayer
    {
        public short[] validNums;
    }


    [System.Serializable]
    public class LodNodeTree
    {
        public byte[] tree;
        public AlphaLayer[] alphaLayers;//在每个层上有效像素数量[layer]
    }

    [System.Serializable]
    public class LayerProperty
    {
        public bool simpleLayer;
    }

    [ExecuteInEditMode]
    public class TerrainToMeshConverter : MonoBehaviour
    {
        public Terrain terrain;
        public int gridSize = 64;
        public float minError = 0.1f;
        public float maxError = 20.0f;
        public float alphaMapThreshold = 0.02f;
        public int maxLodLevel = 3;
        public float lodPower = 1.0f;
        public bool staticLodMesh;
        public bool useSubMesh = true;
        public bool onlySingleMesh = false;

        public Texture2D bakedControlTexture;

        public Material materialFirst;
        public Material materialAdd;
        public Material materialBase;

        public LodNodeTree[] trees;
        public TerrainToMeshTile[] tiles;
        public LayerProperty[] layerProperties;
        public Node[] roots { get; set; }
        
        public void OnEnable()
        {
            if (!staticLodMesh) {
                ClearChildren();
                LoadNodes();
                CollectInfos();
            } else {
                if (tiles != null) {
                    foreach (TerrainToMeshTile tile in tiles) {
                        tile.UpdateLightmap(terrain.lightmapIndex, terrain.lightmapScaleOffset);
                    }
                }
            }
            
        }

        public void LoadNodes()
        {
            roots = new Node[maxLodLevel + 1];
            for (int i = 0; i <= maxLodLevel; i++) {
                Node node = new Node(0, 0, terrain.terrainData.heightmapWidth - 1);
                node.CreateChildFromBytes(trees[i].tree);
                node.SetAlphaBytes(trees[i].alphaLayers);
                roots[i] = node;
            }

        }

        public void ClearChildren()
        {
            var children = new List<GameObject>();
            foreach (Transform child in transform) children.Add(child.gameObject);
            children.ForEach(child => DestroyImmediate(child));
        }

        public void CollectInfos()
        {
            Texture2D baseTexture = TerrainToMeshTool.BakeBaseTexture(terrain.terrainData);
            bakedControlTexture = TerrainToMeshTool.BakeControlTexture(terrain.terrainData, roots[0],gridSize, 4);
            TerrainData terrainData = terrain.terrainData;
            float[,] heights = terrain.terrainData.GetHeights(0, 0, terrain.terrainData.heightmapWidth, terrain.terrainData.heightmapHeight);
            //Material matBase = new Material(Shader.Find("Diffuse"));
            Material matBase = new Material(materialBase);
            matBase.SetTexture("_MainTex", baseTexture);
            List<Material> matAdd = new List<Material>();
            List<Material> matFirst = new List<Material>();
            for (int l = 0; l < terrainData.alphamapLayers; l++) {
                LayerProperty lp = l < layerProperties.Length ? layerProperties[l] : null;
                matAdd.Add(TerrainToMeshTool.GetMaterial(terrain, l, materialAdd,lp));
                matFirst.Add(TerrainToMeshTool.GetMaterial(terrain, l, materialFirst,lp));
            }

            int w = terrainData.heightmapWidth - 1;
            int gridNumX = w / gridSize;
            tiles = new TerrainToMeshTile[gridNumX * gridNumX];

            for (int x = 0; x < gridNumX; x++) {
                for (int y = 0; y < gridNumX; y++) {
                    GameObject objGrid = new GameObject("mesh_" + x + "_" + y);
                    objGrid.transform.SetParent(this.transform, false);
                    TerrainToMeshTile tile = objGrid.AddComponent<TerrainToMeshTile>();
                    tiles[y * gridNumX + x] = tile;
                    tile.matBase = matBase;
                    tile.matAdd = matAdd;
                    tile.matFirst = matFirst;
                    tile.lodLevel = -1;
                    tile.terrainData = terrainData;
                    tile.heights = heights;
                    tile.roots = roots;
                    tile.trees = new Node[roots.Length];
                    tile.useSubMesh = useSubMesh;
                    tile.lodPower = lodPower;
                    tile.onlySingleMesh = onlySingleMesh;
                    tile.terrainMaterial = terrain.materialTemplate;
                    tile.bakedControlTexture = bakedControlTexture;
                    for (int lod = 0; lod < roots.Length; lod++) {
                        tile.trees[lod] = roots[lod].FindSizeNode(x * gridSize, y * gridSize, gridSize);
                        TerrainToMeshTool.SetNodeSkirts(tile.trees[lod], tile.trees[lod]);
                    }
                }
            }

            for (int x = 0; x < gridNumX; x++) {
                for (int y = 0; y < gridNumX; y++) {
                    tiles[y * gridNumX + x].CollectMeshInfo(maxLodLevel);
                }
            }
        }

        public void ClearCollectedInfo() {
            for (int i = 0; i < tiles.Length; i++) {
                tiles[i].ClearCollectedInfo();
            }
        }

        public void CreateStaticMeshes() {
            for (int i = 0; i < tiles.Length; i++) {
                tiles[i].CreateStaticChildren();
                tiles[i].UpdateLightmap(terrain.lightmapIndex, terrain.lightmapScaleOffset);
            }
        }

        public int GetMemorySize() {
            int totalSize = 0;
            for (int i = 0; i < tiles.Length; i++) {
                for(int l = 0; l < tiles[i].lodMeshInfos.Length; l++) {
                    totalSize += tiles[i].lodMeshInfos[l].GetMemorySize();
                }
            }
            return totalSize;
        }

        public void Update()
        {
            if (!staticLodMesh) {
                TerrainData terrainData = terrain.terrainData;
                int w = terrainData.heightmapWidth - 1;
                int gridNumX = w / gridSize;
                Vector2 camera = new Vector2(Camera.main.transform.position.x, Camera.main.transform.position.z);
                if(CameraManager.Instance && CameraManager.Instance.controller.GetFollowTargetObject()) {
                    Vector3 targetPos = CameraManager.Instance.controller.GetFollowTargetObject().transform.position;
                    camera = new Vector2(targetPos.x, targetPos.z);
                }
                float viewDistance = Camera.main.farClipPlane;
                for (int x = 0; x < gridNumX; x++) {
                    for (int y = 0; y < gridNumX; y++) {
                        Vector2 center = new Vector2(transform.position.x, transform.position.z) + new Vector2(y * gridSize, x * gridSize) + new Vector2(gridSize, gridSize) * 0.5f;
                        float t = Mathf.Clamp01(((center - camera).magnitude - gridSize / 2) / viewDistance);
                        tiles[y * gridNumX + x].newLodLevel = Mathf.Min((int)(maxLodLevel * Mathf.Pow(t,lodPower)), maxLodLevel);
                    }
                }
                for (int x = 0; x < gridNumX; x++) {
                    for (int y = 0; y < gridNumX; y++) {
                        Vector2 center = new Vector2(transform.position.x, transform.position.z) + new Vector2(y * gridSize, x * gridSize) + new Vector2(gridSize, gridSize) * 0.5f;
                        float t = 1 - Mathf.Clamp01((center - camera).magnitude / viewDistance);
                        tiles[y * gridNumX + x].newLodLevel = Mathf.Min((int)(maxLodLevel * (1 - t * t)), maxLodLevel);
                        if (tiles[y * gridNumX + x].lodLevel != tiles[y * gridNumX + x].newLodLevel) {
                            tiles[y * gridNumX + x].DynamicUpdateChildren();
                            tiles[y * gridNumX + x].UpdateLightmap(terrain.lightmapIndex, terrain.lightmapScaleOffset);
                        }
                    }
                }
            }
        }
    }

}

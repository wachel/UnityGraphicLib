using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace TerrainConverter
{
    class Node
    {
        public Node(int x, int y, int size)
        {
            this.x = x; this.y = y; this.size = size; swapEdge = false;
        }
        public int x, y;
        public int size;
        public bool swapEdge;
        public int validNum;
        public Node[] childs = null;

        //2 6 3
        //5 8 7
        //0 4 1
        public int[] vertexIndices = new int[9];

        public void PostorderTraversal(System.Action<Node> fun)
        {
            if (childs != null) {
                for (int i = 0; i < 4; i++) {
                    childs[i].PostorderTraversal(fun);
                }
            }
            fun(this);
        }
        public void PreorderTraversal(System.Action<Node> fun)
        {
            fun(this);
            if (childs != null) {
                for (int i = 0; i < 4; i++) {
                    childs[i].PostorderTraversal(fun);
                }
            }
        }
        public void TraversalSize(int fsize,System.Action<Node>fun)
        {
            if (size > fsize) {
                if (childs != null) {
                    for (int i = 0; i < 4; i++) {
                        childs[i].TraversalSize(fsize,fun);
                    }
                }
            } else {
                fun(this);
            }
        }
        public Node FindNode(int fx,int fy)
        {
            if(childs == null) {
                return this;
            } else {
                int index = (fy < y + size / 2.0f ? 0 : 2) + (fx < x + size / 2.0f ? 0 : 1);
                return childs[index].FindNode(fx, fy);
            }
        }
        public Node FindSizeNode(int fx, int fy,int fsize)
        {
            if (fsize == size) {
                return this;
            } else if(fsize < size){
                int index = (fy < y + size / 2 ? 0 : 2) + (fx < x + size / 2 ? 0 : 1);
                return childs[index].FindSizeNode(fx, fy,fsize);
            }
            return null;
        }
    }

    public class MeshInfo
    {
        public MeshInfo(Mesh mesh,int validNum,int gridX,int gridY,int layer)
        {
            this.mesh = mesh;this.validNum = validNum;this.gridX = gridX;this.gridY = gridY;this.layer = layer;
        }
        public Mesh mesh;
        public int validNum;
        public int gridX;
        public int gridY;
        public int layer;
    }

    [CustomEditor(typeof(TerrainToMeshConverter))]
    public class TerrainToMeshConverterInspector : Editor
    {
        TerrainToMeshConverter converter;
        public void OnEnable()
        {
            converter = target as TerrainToMeshConverter;
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            if (converter.terrain) {
                GUILayout.BeginHorizontal();
                int gridNum = (converter.terrain.terrainData.heightmapWidth - 1) / converter.gridSize;

                if (GUILayout.Button("生成完整网格")) {
                    var children = new List<GameObject>();
                    foreach (Transform child in converter.transform) children.Add(child.gameObject);
                    children.ForEach(child => DestroyImmediate(child));

                    List<MeshInfo>[,] meshes = new List<MeshInfo>[gridNum, gridNum];
                    for (int i = 0; i < gridNum; i++) {
                        for (int j = 0; j < gridNum; j++) {
                            meshes[i, j] = new List<MeshInfo>();
                        }
                    }
                    List<MeshInfo> ms = CreateMeshes(converter.gridSize, -1, converter.error);
                    foreach (MeshInfo m in ms) {
                        meshes[m.gridX, m.gridY].Add(m);
                    }
                    CreateObjects(meshes);
                }

                if (GUILayout.Button("生成分层网格")) {
                    var children = new List<GameObject>();
                    foreach (Transform child in converter.transform) children.Add(child.gameObject);
                    children.ForEach(child => DestroyImmediate(child));

                    List<MeshInfo>[,] meshes = new List<MeshInfo>[gridNum, gridNum];
                    for (int i = 0; i < gridNum; i++) {
                        for (int j = 0; j < gridNum; j++) {
                            meshes[i, j] = new List<MeshInfo>();
                        }
                    }
                    List<MeshInfo> ms = CreateMeshes(converter.gridSize, -1, converter.error);
                    foreach (MeshInfo m in ms) {
                        meshes[m.gridX, m.gridY].Add(m);
                    }

                    for (int l = 0; l < converter.terrain.terrainData.alphamapLayers; l++) {
                        ms = CreateMeshes(converter.gridSize, l, converter.error);
                        foreach (MeshInfo m in ms) {
                            meshes[m.gridX, m.gridY].Add(m);
                        }
                    }

                    CreateObjects(meshes);
                }
                GUILayout.EndHorizontal();
            }
        }

        Material GetMaterial(int layer,bool bFirst)
        {
            TerrainData td = converter.terrain.terrainData;
            Material mat;
            if (layer != -1) {
                mat = bFirst ? new Material(Shader.Find("Unlit/TerrainFirst")) : new Material(Shader.Find("Unlit/TerrainAdd"));
                mat.SetTexture("_MainTex", td.splatPrototypes[layer].texture);
                Vector2 tileSize = td.splatPrototypes[layer].tileSize;
                mat.mainTextureScale = new Vector2(td.size.x / tileSize.x, td.size.z / tileSize.y);
                mat.mainTextureOffset = td.splatPrototypes[layer].tileOffset;
                mat.SetTexture("_SplatAlpha", td.alphamapTextures[layer / 4]);
                mat.SetFloat("_SplatIndex", layer % 4);
            } else {
                mat = new Material(Shader.Find("Diffuse"));
            }
            return mat;
        }

        Texture2D BakeBaseTexture()
        {
            TerrainData td = converter.terrain.terrainData;
            Material mat = new Material(Shader.Find("Hidden/BakeBaseTexture"));
            int baseMapResolution = td.baseMapResolution;
            RenderTexture rt = RenderTexture.GetTemporary(baseMapResolution, baseMapResolution);
            RenderTexture.active = rt;
            Graphics.Blit(null, mat, 0);
            for(int layer = 0; layer<converter.terrain.terrainData.alphamapLayers; layer++) {
                mat.SetTexture("_MainTex", td.splatPrototypes[layer].texture);
                Vector2 tileSize = td.splatPrototypes[layer].tileSize;
                mat.mainTextureScale = new Vector2(td.size.x / tileSize.x, td.size.z / tileSize.y);
                mat.mainTextureOffset = td.splatPrototypes[layer].tileOffset;
                mat.SetVector("_MainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
                mat.SetTexture("_SplatAlpha", td.alphamapTextures[layer / 4]);
                mat.SetFloat("_SplatIndex", layer % 4);
                Graphics.Blit(mat.mainTexture, mat, 1);
            }
            Texture2D result = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, true);
            result.ReadPixels(new Rect(0, 0, rt.width, rt.height),0,0);
            result.Apply();
            RenderTexture.ReleaseTemporary(rt);
            return result;
        }

        void CreateObjects(List<MeshInfo>[,] meshes)
        {
            Material matBase = new Material(Shader.Find("Diffuse"));
            matBase.mainTexture = BakeBaseTexture();
            List<Material> matAdd = new List<Material>();
            List<Material> matFirst = new List<Material>();
            for(int l = 0; l<converter.terrain.terrainData.alphamapLayers; l++) {
                matAdd.Add(GetMaterial(l, false));
                matFirst.Add(GetMaterial(l, true));
            }

            for (int i = 0; i < meshes.GetLength(0); i++) {
                for(int j = 0; j < meshes.GetLength(1); j++) {
                    Mesh fullMesh = null;
                    int maxValidLayer = 0;
                    int maxValidNum = 0;
                    List<MeshInfo> group = meshes[i, j];
                    group.Sort((MeshInfo m0, MeshInfo m1) => { return m1.validNum.CompareTo(m0.validNum); });
                    foreach (var m in group) {
                        if(m.layer == -1) {
                            fullMesh = m.mesh;
                        } else {
                            if(m.validNum > maxValidNum) {
                                maxValidNum = m.validNum;
                                maxValidLayer = m.layer;
                            }
                        }
                    }

                    if (group.Count > 0) {
                        GameObject obj = new GameObject("mesh_" + group[0].gridX.ToString() + "_" + group[0].gridY.ToString());
                        obj.transform.SetParent(converter.transform);
                        Renderer[] baseRenderer = new Renderer[1];
                        GameObject baseObj = new GameObject("base");
                        {
                            MeshRenderer renderer = baseObj.AddComponent<MeshRenderer>();
                            MeshFilter filter = baseObj.AddComponent<MeshFilter>();
                            filter.sharedMesh = fullMesh;
                            renderer.sharedMaterial = matBase;
                            baseObj.transform.SetParent(obj.transform);
                            baseRenderer[0] = renderer;
                        }

                        List<Renderer> splatRenderers = new List<Renderer>();
                        foreach (var m in group) {
                            if (m.layer != -1) {
                                GameObject subObj = new GameObject("mesh_" + m.gridX.ToString() + "_" + m.gridY.ToString() + "_" + m.layer.ToString());
                                MeshRenderer renderer = subObj.AddComponent<MeshRenderer>();
                                MeshFilter filter = subObj.AddComponent<MeshFilter>();
                                filter.sharedMesh = m.layer == maxValidLayer ? fullMesh : m.mesh;
                                renderer.sharedMaterial = m.layer == maxValidLayer ? matFirst[m.layer] : matAdd[m.layer];
                                subObj.transform.SetParent(obj.transform);
                                splatRenderers.Add(renderer);
                            }
                        }
                        LOD[] lods = new LOD[2];
                        lods[0].renderers = splatRenderers.ToArray();
                        lods[0].screenRelativeTransitionHeight = 0.4f;
                        lods[1].renderers = baseRenderer;
                        lods[1].screenRelativeTransitionHeight = 0f;
                        LODGroup lodg = obj.AddComponent<LODGroup>();
                        lodg.SetLODs(lods);
                    }
                }
            }

        }

        float GetHeightError(float[,] heights, int x, int y, int step, out bool swapEdge)
        {
            float p0 = heights[x, y];
            float p1 = heights[x + step, y];
            float p2 = heights[x, y + step];
            float p3 = heights[x + step, y + step];
            float center = heights[x + step / 2, y + step / 2];
            float bottom = heights[x + step / 2, y];
            float left = heights[x, y + step / 2];
            float top = heights[x + step / 2, y + step];
            float right = heights[x + step, y + step / 2];
            float error0 = Mathf.Abs(center - (p0 + p3) / 2);
            float error1 = Mathf.Abs(center - (p1 + p2) / 2);
            swapEdge = error0 < error1;

            float error = Mathf.Min(error0, error1);
            error += Mathf.Abs(bottom - (p0 + p1) / 2);
            error += Mathf.Abs(left - (p0 + p2) / 2);
            error += Mathf.Abs(top - (p2 + p3) / 2);
            error += Mathf.Abs(right - (p3 + p1) / 2);
            return error;
        }

        bool CheckSourrond(Node root, int x, int y, int size)
        {
            if (x - size >= 0) {
                Node node = root.FindSizeNode(x - size, y, size);
                if(node.childs != null  && (node.childs[1].childs != null || node.childs[3].childs != null)) {
                    return false;
                }
            }
            if(x + size + size < root.size) {
                Node node = root.FindSizeNode(x + size, y, size);
                if (node.childs != null && (node.childs[0].childs != null || node.childs[2].childs != null)) {
                    return false;
                }
            }

            if (y - size >= 0) {
                Node node = root.FindSizeNode(x, y - size, size);
                if (node.childs != null && (node.childs[2].childs != null || node.childs[3].childs != null)) {
                    return false;
                }
            }
            if (y + size + size < root.size) {
                Node node = root.FindSizeNode(x, y + size, size);
                if (node.childs != null && (node.childs[0].childs != null || node.childs[1].childs != null)) {
                    return false;
                }
            }
            
            return true;
        }

        //2 3
        //0 1
        void AddNode(Node root)
        {
            root.childs = new Node[4];
            int half = root.size / 2;
            root.childs[0] = new Node(root.x, root.y, half);
            root.childs[1] = new Node(root.x + half, root.y, half);
            root.childs[2] = new Node(root.x, root.y + half, half);
            root.childs[3] = new Node(root.x + half, root.y + half, half);
            if (half > 1) {
                for (int i = 0; i < 4; i++) {
                    AddNode(root.childs[i]);
                }
            }
        }

        struct VecInt2
        {
            public VecInt2(int x, int y) { this.x = x; this.y = y; }
            public int x, y;
        }

        //2 6 3
        //5 8 7
        //0 4 1
        void AddVertices(Node node,int i00,int i10,int i01,int i11,List<VecInt2> vertices)
        {
            node.vertexIndices[0] = i00;
            node.vertexIndices[1] = i10;
            node.vertexIndices[2] = i01;
            node.vertexIndices[3] = i11;
            if (node.childs != null && node.validNum > 0) {
                node.vertexIndices[4] = vertices.Count + 0;
                node.vertexIndices[5] = vertices.Count + 1;
                node.vertexIndices[6] = vertices.Count + 2;
                node.vertexIndices[7] = vertices.Count + 3;
                node.vertexIndices[8] = vertices.Count + 4;
                vertices.Add(new VecInt2(node.x + node.size / 2, node.y));
                vertices.Add(new VecInt2(node.x, node.y + node.size / 2));
                vertices.Add(new VecInt2(node.x + node.size / 2, node.y + node.size));
                vertices.Add(new VecInt2(node.x + node.size, node.y + node.size / 2));
                vertices.Add(new VecInt2(node.x + node.size / 2, node.y + node.size / 2));
                AddVertices(node.childs[0], node.vertexIndices[0], node.vertexIndices[4], node.vertexIndices[5], node.vertexIndices[8], vertices);
                AddVertices(node.childs[1], node.vertexIndices[4], node.vertexIndices[1], node.vertexIndices[8], node.vertexIndices[7], vertices);
                AddVertices(node.childs[2], node.vertexIndices[5], node.vertexIndices[8], node.vertexIndices[2], node.vertexIndices[6], vertices);
                AddVertices(node.childs[3], node.vertexIndices[8], node.vertexIndices[7], node.vertexIndices[6], node.vertexIndices[3], vertices);
            }
        }

        bool IsSizeLeaf(Node root, int x, int y, int size)
        {
            Node node = root.FindSizeNode(x, y, size);
            if(node != null && node.childs == null) {
                return true;
            }
            return false;
        }

        void AddIndices(List<int>indices,int[] nodeIndices,int a0,int a1,int a2)
        {
            indices.Add(nodeIndices[a0]);
            indices.Add(nodeIndices[a1]);
            indices.Add(nodeIndices[a2]);
        }

        bool TestAlphaMap(float[,,]alphamaps, int x, int y,int size,int layer)
        {
            if (size == 0) {
                size = 1;
            }
            for(int i= 0; i<size; i++) {
                for(int j = 0; j < size; j++) {
                    if(alphamaps[x + i, y + j, layer] > converter.alphaMapThreshold) {
                        return true;
                    }
                }
            }
            return false;
        }

        List<MeshInfo> CreateMeshes(int gridSize,int alphaLayer, float maxError)
        {
            int w = converter.terrain.terrainData.heightmapWidth;
            int h = converter.terrain.terrainData.heightmapHeight;
            float[,] heights = converter.terrain.terrainData.GetHeights(0, 0, w, h);
            int aw = converter.terrain.terrainData.alphamapWidth;
            int ah = converter.terrain.terrainData.alphamapHeight;
            float[,,] alphamaps = converter.terrain.terrainData.GetAlphamaps(0, 0, aw, ah);

            Node root = new Node(0, 0, w);
            AddNode(root);

            root.PostorderTraversal( (Node node) => {
                if (node.size == 1) {
                    if (alphaLayer == -1) {
                        node.validNum = 1;
                    } else {
                        node.validNum = TestAlphaMap(alphamaps, node.x * aw / (w - 1), node.y * ah / (h - 1), aw / (w - 1), alphaLayer) ? 1 : 0;
                    }
                } else {
                    node.validNum = node.childs[0].validNum + node.childs[1].validNum + node.childs[2].validNum + node.childs[3].validNum;
                }
            });

            for (int m = 1; 1 << m < w; m++) {
                int step = 1 << m;
                root.TraversalSize(step, (Node node) => {
                    bool allChildrenIsMerged = node.childs != null && node.childs[0].childs == null && node.childs[1].childs == null && node.childs[2].childs == null && node.childs[3].childs == null;
                    if (allChildrenIsMerged) {
                        if (GetHeightError(heights, node.x, node.y, node.size, out node.swapEdge) * converter.terrain.terrainData.size.y < maxError && CheckSourrond(root, node.x, node.y, node.size)) {
                            node.childs = null;
                        }
                    }
                });
            }

            List<MeshInfo> meshes = new List<MeshInfo>();
            root.TraversalSize(gridSize, (Node _subRoot) => {
                Node subRoot = _subRoot;

                List<Vector3> vertices = new List<Vector3>();
                List<int> indices = new List<int>();
                List<Vector3> normals = new List<Vector3>();
                List<Vector2> uvs = new List<Vector2>();
                Vector3 size = converter.terrain.terrainData.size;
                List<VecInt2> intVertices = new List<VecInt2>();

                intVertices.Add(new VecInt2(subRoot.x, subRoot.y));
                intVertices.Add(new VecInt2(subRoot.x + subRoot.size, subRoot.y));
                intVertices.Add(new VecInt2(subRoot.x, subRoot.y + subRoot.size));
                intVertices.Add(new VecInt2(subRoot.x + subRoot.size, subRoot.y + subRoot.size));
                AddVertices(subRoot, 0, 1, 2, 3, intVertices);

                for(int i = 0; i < intVertices.Count; i++) {
                    float y0 = (intVertices[i].x) / (w - 1.0f);
                    float x0 = (intVertices[i].y) / (h - 1.0f);
                    vertices.Add(Vector3.Scale(new Vector3(x0, heights[intVertices[i].x, intVertices[i].y], y0), size));
                    normals.Add(converter.terrain.terrainData.GetInterpolatedNormal(x0, y0));
                    uvs.Add(new Vector2(x0, y0));
                }

                subRoot.PreorderTraversal((Node node) => {
                    if(node.childs != null) {
                        //x - 1
                        //为了消除T接缝，如果相邻格子比自己大，则靠近大格子的两个三角形要合并为一个
                        if(node.childs[0].childs == null  && node.childs[2].childs == null && (node.childs[0].validNum > 0 || node.childs[2].validNum > 0) && IsSizeLeaf(root, node.x - 1, node.y, node.size)) {
                            AddIndices(indices, node.vertexIndices, 0, 8, 2);
                        } else {
                            if(node.childs[0].childs == null && node.childs[0].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 0, 8, 5);
                            }
                            if(node.childs[2].childs == null && node.childs[2].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 5, 8, 2);
                            }
                        }
                        //y - 1
                        if (node.childs[0].childs == null && node.childs[1].childs == null && (node.childs[0].validNum> 0 || node.childs[1].validNum> 0) && IsSizeLeaf(root, node.x, node.y - 1, node.size)) {
                            AddIndices(indices, node.vertexIndices, 0, 1, 8);
                        } else {
                            if (node.childs[0].childs == null && node.childs[0].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 0, 4, 8);
                            }
                            if (node.childs[1].childs == null && node.childs[1].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 4, 1, 8);
                            }
                        }

                        //x + 1
                        if (node.childs[1].childs == null && node.childs[3].childs == null && (node.childs[1].validNum > 0 || node.childs[3].validNum > 0) && IsSizeLeaf(root, node.x + node.size + 1, node.y, node.size)) {
                            AddIndices(indices, node.vertexIndices, 1, 3, 8);
                        } else {
                            if (node.childs[1].childs == null && node.childs[1].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 1, 7, 8);
                            }
                            if (node.childs[3].childs == null && node.childs[3].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 7, 3, 8);
                            }
                        }
                        //y + 1
                        if (node.childs[2].childs == null && node.childs[3].childs == null && (node.childs[2].validNum > 0 || node.childs[3].validNum > 0) && IsSizeLeaf(root, node.x, node.y + node.size + 1, node.size)) {
                            AddIndices(indices, node.vertexIndices, 3, 2, 8);
                        } else {
                            if (node.childs[2].childs == null && node.childs[2].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 8, 6, 2);
                            }
                            if (node.childs[3].childs == null && node.childs[3].validNum > 0) {
                                AddIndices(indices, node.vertexIndices, 8, 3, 6);
                            }
                        }
                    }
                });

                if (indices.Count > 0) {

                    Mesh mesh = new Mesh();
                    mesh.vertices = vertices.ToArray();
                    mesh.normals = normals.ToArray();
                    mesh.uv = uvs.ToArray();
                    mesh.triangles = indices.ToArray();
                    mesh.RecalculateBounds();
                    meshes.Add(new MeshInfo(mesh, subRoot.validNum, subRoot.x / subRoot.size, subRoot.y / subRoot.size, alphaLayer));
                }

            });

            return meshes;
        }
    }
}
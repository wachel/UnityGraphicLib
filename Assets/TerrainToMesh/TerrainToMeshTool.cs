﻿using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;


namespace TerrainConverter
{
    public class Node
    {
        public Node(int x, int y, int size)
        {
            this.x = x; this.y = y; this.size = size;
        }
        public int x, y;
        public int size;
        public int GetMaxValidNumIndex()
        {
            int maxNums = 0;
            int maxIndex = 0;
            for(int i =0; i < validNums.Length; i++) {
                if(validNums[i] > maxNums) {
                    maxNums = validNums[i];
                    maxIndex = i;
                }
            }
            return maxIndex;
        }
        public int[] GetMaxNValieNumIndices(int n) {
            int[] indices = new int[validNums.Length];
            for(int i =0; i < indices.Length; i++) {
                indices[i] = i;
            }
            System.Array.Sort(indices,(int a,int b)=> { return (validNums[b] * 100 + b) - (validNums[a] * 100 + a); });
            int[] result = new int[n];
            for(int i= 0; i<n; i++) {
                if (i < indices.Length) {
                    result[i] = indices[i];
                }
            }
            return result;
        }
        public int GetValidNum(int layer)
        {
            if (layer == -1 || validNums == null) {
                return size * size;
            } else {
                return validNums[layer];
            }
        }
        public int[] validNums;
        public bool swapEdge;
        public float error;//合并网格从子节点收集的误差
        public Node[] childs = null;

        //记录那些边要被擦掉
        //+-2-+
        //1 + 3
        //+-0-+
        public byte mergeTriangle;
        public byte skirts;

        //2 6 3
        //5 8 7
        //0 4 1
        public int[] vertexIndices = new int[9];

        //  45 
        //3 ** 6
        //2 ** 7
        //  10
        public int[] skirtsIndices = new int[8];

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
                    childs[i].PreorderTraversal(fun);
                }
            }
        }
        public void TraversalSize(int fsize, System.Action<Node> fun)
        {
            if (size > fsize) {
                if (childs != null) {
                    for (int i = 0; i < 4; i++) {
                        childs[i].TraversalSize(fsize, fun);
                    }
                }
            } else {
                fun(this);
            }
        }
        public Node FindLeaf(int fx, int fy)
        {
            if (childs == null) {
                return this;
            } else {
                int index = (fy < y + size / 2 ? 0 : 2) + (fx < x + size / 2 ? 0 : 1);
                return childs[index].FindLeaf(fx, fy);
            }
        }
        public Node FindSizeNode(int fx, int fy, int fsize)
        {
            if (fsize == size) {
                return this;
            } else if (fsize < size) {
                int index = (fy < y + size / 2 ? 0 : 2) + (fx < x + size / 2 ? 0 : 1);
                if (childs == null || childs[index] == null) {
                    int a = 0;
                } else {
                    return childs[index].FindSizeNode(fx, fy, fsize);
                }
            }
            return null;
        }


        public void ToBytes(List<byte> bytes)
        {
            PreorderTraversal((Node node) => {
                if (node.childs != null) {
                    byte flag = 0;
                    for (int i = 0; i < 4; i++) {
                        flag |= node.childs[i].childs != null ? (byte)(1 << i) : (byte)0;
                    }
                    flag |= (byte)(node.mergeTriangle << 4);
                    bytes.Add(flag);
                }
            });
        }

        public AlphaLayer[] GetAlphaBytes()
        {
            AlphaLayer[] result = new AlphaLayer[validNums.Length];
            for (int layer = 0; layer < validNums.Length; layer++) {
                List<short> nums = new List<short>();
                PreorderTraversal((Node node) => {
                    if (node.childs == null) {
                        nums.Add((short)node.validNums[layer]);
                    }
                });
                result[layer] = new AlphaLayer();
                result[layer].validNums = nums.ToArray();
            }
            return result;
        }

        public void CreateChildFromBytes(byte[] bytes, ref int startIndex)
        {
            //只要调用到这个函数，说明node肯定包含有四个子节点
            childs = new Node[4];
            int half = size / 2;
            childs[0] = new Node(x, y, half);
            childs[1] = new Node(x + half, y, half);
            childs[2] = new Node(x, y + half, half);
            childs[3] = new Node(x + half, y + half, half);

            Node node = new Node(x, y, size);
            byte flag = bytes[startIndex];
            mergeTriangle = (byte)(flag >> 4);
            startIndex++;
            for (int i = 0; i < 4; i++) {
                if ((flag & (byte)(1 << i)) != 0) {
                    childs[i].CreateChildFromBytes(bytes, ref startIndex);
                }
            }
        }

        public void CreateChildFromBytes(byte[] bytes)
        {
            int startInde = 0;
            CreateChildFromBytes(bytes, ref startInde);
        }

        public void SetAlphaBytes(AlphaLayer[] layerBytes)
        {
            PreorderTraversal((Node node) => {
                node.validNums = new int[layerBytes.Length];
            });

            for (int layer = 0; layer < layerBytes.Length; layer++) {
                short[] nums = layerBytes[layer].validNums;
                int index = 0;
                PreorderTraversal((Node node) => {
                    if (node.childs == null) {
                        node.validNums[layer] = nums[index];
                        index++;
                    }
                });
                PostorderTraversal((Node node) => {
                    if (node.childs != null) {
                        node.validNums[layer] = node.childs[0].validNums[layer] + node.childs[1].validNums[layer] + node.childs[2].validNums[layer] + node.childs[3].validNums[layer];
                    }
                });
            }

        }
    }


    public class MeshInfo
    {
        public MeshInfo(Mesh mesh, int validNum, int gridX, int gridY, int layer)
        {
            this.mesh = mesh; this.validNum = validNum; this.gridX = gridX; this.gridY = gridY; this.layer = layer;
        }
        public Mesh mesh;
        public int validNum;
        public int gridX;
        public int gridY;
        public int layer;
    }

    public static class TerrainToMeshTool
    {
        public static Material GetMaterial(Terrain terrain,int layer, Material template,LayerProperty property)
        {
            TerrainData td = terrain.terrainData;
            Material mat;
            if (layer != -1) {
                mat = new Material(template);
                mat.SetTexture("_Splat0", td.splatPrototypes[layer].texture);
                mat.SetTexture("_Normal0", td.splatPrototypes[layer].normalMap);
                Vector2 tileSize = td.splatPrototypes[layer].tileSize;
                mat.SetTextureScale("_Splat0", new Vector2(td.size.x / tileSize.x, td.size.z / tileSize.y));
                mat.SetTextureOffset("_Splat0", td.splatPrototypes[layer].tileOffset);
                mat.SetTexture("_Control", td.alphamapTextures[layer / 4]);
                //mat.SetTexture("unity_Lightmap", LightmapSettings.lightmaps[terrain.lightmapIndex].lightmapColor);
                mat.SetFloat("_SplatIndex", layer % 4);
                mat.EnableKeyword("_MESH_TERRAIN");
                if (property != null) {
                    if (property.simpleLayer) {
                        mat.EnableKeyword("_SIMPLE_LAYER");
                    }
                    else {
                        mat.DisableKeyword("_SIMPLE_LAYER");
                    }
                }
            } else {
                mat = new Material(Shader.Find("Diffuse"));
            }
            return mat;
        }

        public static Material GetSingleMeshMaterial(Terrain terrain, int layer, Material template) {
            TerrainData td = terrain.terrainData;
            Material mat;
            if (layer != -1) {
                mat = new Material(template);
                mat.SetTexture("_Splat0", td.splatPrototypes[layer].texture);
                mat.SetTexture("_Normal0", td.splatPrototypes[layer].normalMap);
                Vector2 tileSize = td.splatPrototypes[layer].tileSize;
                mat.SetTextureScale("_Splat0", new Vector2(td.size.x / tileSize.x, td.size.z / tileSize.y));
                mat.SetTextureOffset("_Splat0", td.splatPrototypes[layer].tileOffset);
                mat.SetTexture("_Control", td.alphamapTextures[layer / 4]);
            } else {
                mat = new Material(Shader.Find("Diffuse"));
            }
            return mat;
        }

        public static Texture2D BakeBaseTexture(TerrainData terrainData) {
            Material mat = new Material(Shader.Find("Hidden/BakeBaseTexture"));
            int baseMapResolution = terrainData.baseMapResolution;
            RenderTexture rt = RenderTexture.GetTemporary(baseMapResolution, baseMapResolution);
            RenderTexture.active = rt;
            rt.DiscardContents();
            Graphics.Blit(null, mat, 0);
            for (int layer = 0; layer < terrainData.alphamapLayers; layer++) {
                //FilterMode filterMode = terrainData.splatPrototypes[layer].texture.filterMode;
                //terrainData.splatPrototypes[layer].texture.filterMode = FilterMode.Point;
                mat.SetTexture("_MainTex", terrainData.splatPrototypes[layer].texture);
                Vector2 tileSize = terrainData.splatPrototypes[layer].tileSize;
                mat.mainTextureScale = new Vector2(terrainData.size.x / tileSize.x, terrainData.size.z / tileSize.y);
                mat.mainTextureOffset = terrainData.splatPrototypes[layer].tileOffset;
                mat.SetVector("_MainTexST", new Vector4(mat.mainTextureScale.x, mat.mainTextureScale.y, mat.mainTextureOffset.x, mat.mainTextureOffset.y));
                mat.SetTexture("_SplatAlpha", terrainData.alphamapTextures[layer / 4]);
                mat.SetFloat("_SplatIndex", layer % 4);
                Graphics.Blit(mat.mainTexture, mat, 1);

                //terrainData.splatPrototypes[layer].texture.filterMode = filterMode;
            }
            Texture2D result = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, false, false);
            result.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            result.Apply(false, true);
            RenderTexture.active = null;
            RenderTexture.ReleaseTemporary(rt);
            return result;
        }

        static void BakeControlTexture(TerrainData terrainData, Node node,Material mat, int gridSize, int maxN) {
            if(node.size > gridSize) {
                for(int i = 0; i<node.childs.Length; i++) {
                    BakeControlTexture(terrainData, node.childs[i], mat, gridSize, maxN);
                }
            } else {
                if(node.x != 0) {
                    //return;
                }
                if(node.y / gridSize == 11 && node.x / gridSize == 0) {

                } else {
                    //return;
                }
                int[] maxIndices = node.GetMaxNValieNumIndices(maxN);
                for(int i =0; i<maxIndices.Length; i++) {
                    float rtSize = terrainData.alphamapWidth;
                    float scale = terrainData.alphamapWidth / (terrainData.heightmapWidth - 1);
                    Rect rect = new Rect(node.y * scale, node.x * scale, node.size * scale, node.size * scale);
                    GL.LoadPixelMatrix(0, rtSize, 0, rtSize);
                    mat.SetTexture("_MainTex", Texture2D.blackTexture);
                    mat.SetTexture("_SplatAlpha", terrainData.alphamapTextures[maxIndices[i] / 4]);
                    mat.SetFloat("_SplatIndex", maxIndices[i] % 4);
                    mat.SetFloat("_TargetIndex", i);
                    float density = (node.validNums[maxIndices[i]] / 1024.0f);
                    mat.SetFloat("_Density", density);
                    mat.SetVector("_SrcRect", new Vector4(rect.x / rtSize, rect.y / rtSize + rect.height / rtSize, rect.width / rtSize, -rect.height / rtSize));
                    //Graphics.Blit(mat.mainTexture, mat, 2);
                    Graphics.DrawTexture(rect, Texture2D.whiteTexture, mat, 2);
                }
            }
        }

        public static Texture2D BakeControlTexture(TerrainData terrainData,Node root,int gridSize,int maxN) {
            Material mat = new Material(Shader.Find("Hidden/BakeBaseTexture"));
            RenderTexture rt = new RenderTexture(terrainData.alphamapWidth, terrainData.alphamapHeight,24,RenderTextureFormat.ARGB32);
            RenderTexture.active = rt;
            rt.DiscardContents();
            GL.Clear(true, true, new Color(0, 0, 0, 0));
            BakeControlTexture(terrainData,root, mat, gridSize, maxN);
            RenderTexture rt2 = new RenderTexture(rt.width, rt.height, 0, RenderTextureFormat.ARGB32);
            RenderTexture.active = rt2;
            Graphics.Blit(rt, mat, 3);
            Texture2D result = new Texture2D(rt2.width, rt2.height, TextureFormat.ARGB32, false, false);
            result.ReadPixels(new Rect(0, 0, rt2.width, rt2.height), 0, 0);
            //result.filterMode = FilterMode.Point;
            result.Apply(false, true);
            RenderTexture.active = null;
            return result;
        }

        public struct VecInt3
        {
            public VecInt3(int x, int y,int z) { this.x = (short)x; this.y = (short)y; this.z = (short)z; }
            public short x, y, z;
        }
        
        public struct VecNormal
        {
            public VecNormal(Vector3 normal) {
                x = (sbyte)(normal.x * 127.0f);
                y = (sbyte)(normal.y * 127.0f);
                z = (sbyte)(normal.z * 127.0f);
            }
            public Vector3 Value { get { return new Vector3(x/127.0f,y/127.0f,z/127.0f); } }
            public sbyte x, y,z;
        }

        //  45 
        //3 ** 6
        //2 ** 7
        //  10
        static readonly int[] skirtsOffsets = {
                1,0,0,0,
                0,0,0,1,
                0,1,1,1,
                1,1,1,0,
        };
        static void AddVertices(Node node, int i00, int i10, int i01, int i11, List<VecInt3> vertices)
        {
            //2 6 3
            //5 8 7
            //0 4 1
            node.vertexIndices[0] = i00;
            node.vertexIndices[1] = i10;
            node.vertexIndices[2] = i01;
            node.vertexIndices[3] = i11;
            if (node.childs != null) {
                node.vertexIndices[4] = vertices.Count + 0;
                node.vertexIndices[5] = vertices.Count + 1;
                node.vertexIndices[6] = vertices.Count + 2;
                node.vertexIndices[7] = vertices.Count + 3;
                node.vertexIndices[8] = vertices.Count + 4;
                vertices.Add(new VecInt3(node.x + node.size / 2, node.y, 0));
                vertices.Add(new VecInt3(node.x, node.y + node.size / 2, 0));
                vertices.Add(new VecInt3(node.x + node.size / 2, node.y + node.size, 0));
                vertices.Add(new VecInt3(node.x + node.size, node.y + node.size / 2, 0));
                vertices.Add(new VecInt3(node.x + node.size / 2, node.y + node.size / 2, 0));
                AddVertices(node.childs[0], node.vertexIndices[0], node.vertexIndices[4], node.vertexIndices[5], node.vertexIndices[8], vertices);
                AddVertices(node.childs[1], node.vertexIndices[4], node.vertexIndices[1], node.vertexIndices[8], node.vertexIndices[7], vertices);
                AddVertices(node.childs[2], node.vertexIndices[5], node.vertexIndices[8], node.vertexIndices[2], node.vertexIndices[6], vertices);
                AddVertices(node.childs[3], node.vertexIndices[8], node.vertexIndices[7], node.vertexIndices[6], node.vertexIndices[3], vertices);
            }


            for (int dir = 0;dir<4; dir++) {
                if((node.skirts & (1<<dir)) != 0) {
                    node.skirtsIndices[dir * 2 + 0] = vertices.Count + 0;
                    node.skirtsIndices[dir * 2 + 1] = vertices.Count + 1;
                    vertices.Add(new VecInt3(node.x + node.size * skirtsOffsets[dir * 4 + 0], node.y + node.size * skirtsOffsets[dir * 4 + 1], node.size));
                    vertices.Add(new VecInt3(node.x + node.size * skirtsOffsets[dir * 4 + 2], node.y + node.size * skirtsOffsets[dir * 4 + 3], node.size));
                }
            }
        }

        public static bool IsSizeLeaf(Node root, int x, int y, int size)
        {
            Node node = root.FindSizeNode(x, y, size);
            if (node != null && node.childs == null) {
                return true;
            }
            return false;
        }

        static void AddIndices(List<int> indices, int t0, int t1, int t2)
        {
            indices.Add(t0);
            indices.Add(t1);
            indices.Add(t2);
        }

        static void AddNodeIndices(List<int> indices, int[] nodeIndices, int a0, int a1, int a2)
        {
            AddIndices(indices,nodeIndices[a0], nodeIndices[a1], nodeIndices[a2]);
        }


        // 2 3      2
        // 0 1    1   3
        //          0
        static readonly int[] points = {0,1,8,4,
                                        2,0,8,5,
                                        3,2,8,6,
                                        1,3,8,7};
        static readonly int[] childIndex = { 1,0,
                                             0,2,
                                             2,3,
                                             3,1};
        static void AddIndicesByNode(List<int>indices,Node subRoot, int alphaLayer)
        {
            //2 6 3 
            //5 8 7
            //0 4 1


            Node node = subRoot;
            for (int dir = 0; dir < 4; dir++) {
                Node child0 = node.childs[childIndex[dir * 2]];
                Node child1 = node.childs[childIndex[dir * 2 + 1]];
                int p0 = points[dir * 4 + 0];
                int p1 = points[dir * 4 + 1];
                int p2 = points[dir * 4 + 2];
                int p3 = points[dir * 4 + 3];
                if ((node.mergeTriangle & (1 << dir)) != 0 && (child0.GetValidNum(alphaLayer) > 0 || child1.GetValidNum(alphaLayer) > 0)) {
                    AddNodeIndices(indices, node.vertexIndices, p0, p1, p2);
                } else {
                    if (child0.childs == null && child0.GetValidNum(alphaLayer) > 0) {
                        AddNodeIndices(indices, node.vertexIndices, p1, p2, p3);
                    }
                    if (child1.childs == null && child1.GetValidNum(alphaLayer) > 0) {
                        AddNodeIndices(indices, node.vertexIndices, p0, p3, p2);
                    }
                }

                if ((node.mergeTriangle & (1 << dir)) != 0) {
                    if ((node.skirts & (1 << dir)) != 0) {
                        //AddIndices(indices, node.vertexIndices[childIndex[dir * 2]], node.vertexIndices[childIndex[dir * 2 + 1]], node.skirtsIndices[dir * 2 + 1]);
                        //AddIndices(indices, node.vertexIndices[childIndex[dir * 2 + 0]], node.skirtsIndices[dir * 2 + 1], node.skirtsIndices[dir * 2]);
                    }
                } else {
                    if ((child0.skirts & (1 << dir)) != 0 && child0.GetValidNum(alphaLayer) > 0) {
                        //  45 
                        //3 23 6
                        //2 01 7
                        //  10
                        AddIndices(indices, child0.vertexIndices[childIndex[dir * 2]], child0.vertexIndices[childIndex[dir * 2 + 1]], child0.skirtsIndices[dir * 2 + 1]);
                        AddIndices(indices, child0.vertexIndices[childIndex[dir * 2 + 0]], child0.skirtsIndices[dir * 2 + 1], child0.skirtsIndices[dir * 2]);
                    }
                    if ((child1.skirts & (1 << dir)) != 0 && child1.GetValidNum(alphaLayer) > 0) {
                        AddIndices(indices, child1.vertexIndices[childIndex[dir * 2]], child1.vertexIndices[childIndex[dir * 2 + 1]], child1.skirtsIndices[dir * 2 + 1]);
                        AddIndices(indices, child1.vertexIndices[childIndex[dir * 2 + 0]], child1.skirtsIndices[dir * 2 + 1], child1.skirtsIndices[dir * 2]);
                    }
                }
            }
            for(int i =0; i<4; i++) {
                if (node.childs[i].childs != null) {
                    AddIndicesByNode(indices, node.childs[i],alphaLayer);
                }
            }
        }

        static List<Vector3> vertices = new List<Vector3>(4096);
        static List<Vector3> normals = new List<Vector3>(4096);
        static List<Vector2> uvs = new List<Vector2>(4096);
        //static List<Vector2> uvs2 = new List<Vector2>(4096);
        //static List<int> indices = new List<int>(65536);

        public static List<VecInt3> GetIntVertices(Node subRoot) {
            List<VecInt3> intVertices = new List<VecInt3>();
            intVertices.Add(new VecInt3(subRoot.x, subRoot.y, 0));
            intVertices.Add(new VecInt3(subRoot.x + subRoot.size, subRoot.y, 0));
            intVertices.Add(new VecInt3(subRoot.x, subRoot.y + subRoot.size, 0));
            intVertices.Add(new VecInt3(subRoot.x + subRoot.size, subRoot.y + subRoot.size, 0));
            AddVertices(subRoot, 0, 1, 2, 3, intVertices);
            return intVertices;
        }

        public static List<VecNormal> GetNormals(List<VecInt3> intVertices, TerrainData terrainData) {
            List<VecNormal> normals = new List<VecNormal>();
            int w = terrainData.heightmapWidth;
            int h = terrainData.heightmapHeight;
            for (int i = 0; i < intVertices.Count; i++) {
                float y0 = (intVertices[i].x) / (w - 1.0f);
                float x0 = (intVertices[i].y) / (h - 1.0f);
                normals.Add( new VecNormal(terrainData.GetInterpolatedNormal(x0, y0)));
            }
            return normals;
        }

        public static List<int[]> GetIndices(Node subRoot, int[] layerIndex) {
            List<int[]> indicesLayers = new List<int[]>();
            for (int i = 0; i < layerIndex.Length; i++) {
                List<int> indices = new List<int>();
                AddIndicesByNode(indices, subRoot, i == 0 ? -1 : layerIndex[i]);
                indicesLayers.Add(indices.ToArray());
            }
            return indicesLayers;
        }


        public static Mesh CreateMesh(TerrainData terrainData, float[,] heights,List<VecInt3>intVertices,List<VecNormal>vecNormals,List<int[]>indices,int layer) { 
    
            int w = terrainData.heightmapWidth;
            int h = terrainData.heightmapHeight;
            
            vertices.Clear();
            normals.Clear();
            uvs.Clear();
            
            Vector3 size = terrainData.size;

            for (int i = 0; i < intVertices.Count; i++) {
                float y0 = (intVertices[i].x) / (w - 1.0f);
                float x0 = (intVertices[i].y) / (h - 1.0f);
                Vector3 vertex = Vector3.Scale(new Vector3(x0, heights[intVertices[i].x, intVertices[i].y], y0), size) - new Vector3(0, intVertices[i].z * 0.5f, 0);
                vertices.Add(vertex);
                normals.Add(vecNormals[i].Value);
                uvs.Add(new Vector2(x0, y0));
            }

            Mesh mesh = new Mesh();
            mesh.SetVertices(vertices);
            mesh.SetNormals(normals);
            mesh.SetUVs(0, uvs);

            if (layer == -1) {
                int subMeshCount = 0;
                for (int i = 0; i < indices.Count; i++) {
                    if (indices[i].Length > 0) {
                        subMeshCount++;
                        mesh.subMeshCount = subMeshCount;
                        mesh.SetTriangles(indices[i], subMeshCount - 1, false);
                    }
                }
            }
            else {
                mesh.SetTriangles(indices[layer], 0, false);
            }

            mesh.RecalculateBounds();
            return mesh;
        }

        ////public static Mesh CreateSingleMesh(Node root, TerrainData terrainData, float[,] heights, int layer ,bool firstLayer)
        //public static Mesh CreateSingleMesh(TerrainData terrainData, float[,] heights, List<VecInt3> intVertices, List<VecNormal> vecNormals, int[] indices, bool firstLayer)
        //{
        //    int w = terrainData.heightmapWidth;
        //    int h = terrainData.heightmapHeight;
        //
        //    vertices.Clear();
        //    normals.Clear();
        //    uvs.Clear();
        //
        //    Vector3 size = terrainData.size;
        //
        //    for (int i = 0; i < intVertices.Count; i++)
        //    {
        //        float y0 = (intVertices[i].x) / (w - 1.0f);
        //        float x0 = (intVertices[i].y) / (h - 1.0f);
        //        vertices.Add(Vector3.Scale(new Vector3(x0, heights[intVertices[i].x, intVertices[i].y], y0), size) - new Vector3(0, intVertices[i].z * 0.5f, 0));
        //        normals.Add(vecNormals[i].Value);
        //        uvs.Add(new Vector2(x0, y0));
        //    }
        //
        //    Mesh mesh = new Mesh();
        //    mesh.SetVertices(vertices);
        //    mesh.SetNormals(normals);
        //    mesh.SetUVs(0, uvs);
        //    
        //    if (indices.Length > 0)
        //    {
        //        mesh.SetTriangles(indices,0);
        //        mesh.RecalculateBounds();
        //        return mesh;
        //    }
        //
        //    return null;
        //}

        //public static List<MeshInfo> CreateMeshes(Node root , TerrainData terrainData,float[,] heights, int gridSize)
        //{
        //    List<MeshInfo> meshes = new List<MeshInfo>();
        //    root.TraversalSize(gridSize, (Node _subRoot) => {
        //        Node subRoot = _subRoot;
        //        bool[] layerValid = new bool[1];
        //
        //        List<VecInt3> intVertices = GetIntVertices(root);
        //        List<VecNormal> vecNormals = GetNormals(intVertices, terrainData);
        //        List<int[]> indices = GetIndices(root, new int[] { 0 });
        //
        //        Mesh mesh = CreateMesh(terrainData,heights,intVertices,vecNormals,indices,-1);
        //        if (mesh != null) {
        //            meshes.Add(new MeshInfo(mesh,subRoot.GetValidNum(0),subRoot.x / subRoot.size,subRoot.y/subRoot.size,0));
        //        }
        //    });
        //
        //    return meshes;
        //}

        static bool IsEdgeNode(Node tree, Node node, int dir)
        {
            switch (dir) {
                case 0: return node.y == tree.y;
                case 1: return node.x == tree.x;
                case 2: return node.y + node.size == tree.y + tree.size;
                case 3: return node.x + node.size == tree.x + tree.size;
                default:
                    break;
            }
            return false;
        }

        // 2 3      2
        // 0 1    1   3
        //          0
        public static void SetNodeSkirts(Node subRoot,Node node)
        {
            for (int dir = 0; dir < 4; dir++) {//
                if (IsEdgeNode(subRoot, node, dir)) {
                    if ((node.mergeTriangle & (1 << dir)) != 0) {
                        node.skirts |= (byte)(1 << dir);
                    } else if (node.childs == null) {
                        node.skirts |= (byte)(1 << dir);
                    } else {
                        SetNodeSkirts(subRoot,node.childs[childIndex[dir * 2]]);
                        SetNodeSkirts(subRoot,node.childs[childIndex[dir * 2 + 1]]);
                    }
                }
            }
        }
    }


}
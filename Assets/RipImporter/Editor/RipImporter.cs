using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
using System.Collections.Generic;

public class RipModel
{
    public uint signature;
    public uint version;
    public int vertexesCnt;
    public int[] faces;
    public string[] textureFiles;
    public string[] shaderFiles;
    public Texture2D[] textures;
    public List<RipAttribute> attributes;

    public string[] meshAttrNames = { "position", "normal", "color", "uv", "uv2", "uv3", "uv4", "tangent", "boneIndex", "boneWeights" };
    public int[] meshAttrSize = { 12, 0, 16, 8, 8, 8, 8, 12, 0, 0 };
    public string[] meshAttrDefault = { "POSITION", "NORMAL", "COLOR", "TEXCOORD", "TEXCOORD2", "TEXCOORD3", "TEXCOORD4", "TANGENT", "BLENDINDICES", "BLENDWEIGHT" };
    public int[] meshAttrIndex = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
}

public class RipAttribute
{
    public bool bSelected = true;
    public string semantic;
    public int semanticIndex;
    public int offset;
    public int size;
    public int[] vertexAttribTypesArray;
    public Vector4[] values;
    public int[,] intValues;
}


public class RipImporter : EditorWindow
{
    [MenuItem("Window/Rip Model Importer")]
    static void OpenImporter()
    {
        RipImporter window = (RipImporter)EditorWindow.GetWindow(typeof(RipImporter));
        window.Show();
    }

    static string extension = ".rip";        // Our custom extension
    static string newExtension = ".asset";        // Extension of newly created asset - it MUST be ".asset", nothing else is allowed...

    public Object oldSelection;
    RipModel model;
    Vector2 scroll;

    public bool flipTriangle;
    public bool flipUV;
    public bool flipUV2;
    public bool recalculateNormal;
    public float scale = 1;


    void OnSelectionChange()
    {
        //LoadModel();
        Repaint();
    }

    int[] GetAttributeArray(int size)
    {
        List<int> rlt = new List<int>();
        for (int i = 0; i<model.attributes.Count; i++) {
            if (model.attributes[i].size == size || size == 0) {
                rlt.Add(i);
            }
        }
        return rlt.ToArray();
    }

    string[] GetAttributeNames(List<RipAttribute>attrs,int[] indices)
    {
        string[] rlt = new string[indices.Length + 1];
        rlt[0] = "Ignore";
        for(int i = 0; i<indices.Length;i++) {
            RipAttribute attr = attrs[indices[i]];
            rlt[i + 1] = attrs[indices[i]].semantic + ((attr.semanticIndex != 0)?(attr.semanticIndex + 1).ToString() :"");
        }
        return rlt;
    }

    int GetDefaultIndexValue(List<RipAttribute> attrs, string defaultName)
    {
        for(int i = 0; i< attrs.Count; i++) {
            RipAttribute attr = attrs[i];
            string attrName = attr.semantic + ((attr.semanticIndex != 0) ? (attr.semanticIndex + 1).ToString() : "");
            if (attrName == defaultName) {
                return i;
            }
        }
        return -1;
    }

    void LoadModel()
    {
        oldSelection = Selection.activeObject;
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);
        if (path.ToLower().EndsWith(".rip")) {
            using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read)) {
                using (BinaryReader bin = new BinaryReader(fs)) {
                    model = ReadModel(bin);
                    model.textures = new Texture2D[model.textureFiles.Length];
                    for (int i = 0; i < model.textureFiles.Length; i++) {
                        string texPath = GetParentPath(path) + "/" + model.textureFiles[i];
                        model.textures[i] = AssetDatabase.LoadAssetAtPath<Texture2D>(texPath);
                        if (model.textures[i] == null) {
                            model.textures[i] = AssetDatabase.LoadAssetAtPath<Texture2D>(texPath.Replace(".dds", ".tga"));
                        }
                    }
                }
            }
            for (int i = 0; i < model.meshAttrNames.Length; i++) {
                model.meshAttrIndex[i] = GetDefaultIndexValue(model.attributes, model.meshAttrDefault[i]);
            }
        }
    }

    void OnGUI()
    {
        if (Selection.activeObject != oldSelection) {
            LoadModel();
        }

        if (model != null) {
            scroll = GUILayout.BeginScrollView(scroll);
            for (int i = 0; i < model.textures.Length; i++) {
                EditorGUILayout.ObjectField(model.textureFiles[i], model.textures[i], typeof(Texture2D), false);
            }
            for(int i = 0; i<model.meshAttrNames.Length; i++) {
                GUILayout.BeginHorizontal();
                GUILayout.Label("get " + model.meshAttrNames[i] + " from ");

                int[] indexArray = GetAttributeArray(model.meshAttrSize[i]);//get valid indices
                string[] names = GetAttributeNames(model.attributes, indexArray);//get valid names

                int selected = 0;
                for(int x =0;x<indexArray.Length;x++) {
                    if(indexArray[x] == model.meshAttrIndex[i]) {
                        selected = x + 1;
                    }
                }
                selected = EditorGUILayout.Popup(selected, names, GUILayout.Width(150));
                model.meshAttrIndex[i] = selected != 0? indexArray[selected - 1]:-1;
                GUILayout.EndHorizontal();
            }
            //for (int i = 0; i < model.attributes.Count; i++) {
            //    model.attributes[i].bSelected = GUILayout.Toggle(model.attributes[i].bSelected, model.attributes[i].semantic);
            //}

            flipTriangle = GUILayout.Toggle(flipTriangle, "Flip Triangle");
            flipUV = GUILayout.Toggle(flipUV, "Flip UV");
            flipUV2 = GUILayout.Toggle(flipUV2, "Flip UV2");
            recalculateNormal = GUILayout.Toggle(recalculateNormal, "Recalulate Normal");
            scale = EditorGUILayout.FloatField("Scale", scale);
            GUILayout.Label("Triangle Num:" + model.faces.Length / 3);
            if (model.meshAttrIndex[8] != -1) {
                RipAttribute attr = model.attributes[model.meshAttrIndex[8]];
                HashSet<int> bones = new HashSet<int>();
                if (attr.vertexAttribTypesArray[0] == 0) {
                    for (int i = 0; i < attr.values.Length; i++) {
                        if (attr.vertexAttribTypesArray.Length > 0) { bones.Add((int)attr.values[i].x); };
                        if (attr.vertexAttribTypesArray.Length > 1) { bones.Add((int)attr.values[i].y); };
                        if (attr.vertexAttribTypesArray.Length > 2) { bones.Add((int)attr.values[i].z); };
                        if (attr.vertexAttribTypesArray.Length > 3) { bones.Add((int)attr.values[i].w); };
                    }
                } else {
                    for (int i = 0; i < attr.intValues.GetLength(0); i++) {
                        for (int j = 0; j < attr.intValues.GetLength(1); j++) {
                            bones.Add(attr.intValues[i, j]);
                        }
                    }
                }
                GUILayout.Label("Bone Num:" + bones.Count);
            }
            if (GUILayout.Button("Import")) {
                Mesh mesh = ImportMesh();
                SaveMesh(mesh);
            }
            GUILayout.EndScrollView();
        }
    }

    Vector3[] ToVector3Array(Vector4[] values,float scale = 1)
    {
        Vector3[] rlt = new Vector3[values.Length];
        for (int i = 0; i < values.Length; i++) {
            rlt[i] = values[i] * scale;
        }
        return rlt;
    }

    Vector2[] ToVector2Array(Vector4[] values,bool flipUV)
    {
        Vector2[] rlt = new Vector2[values.Length];
        for (int i = 0; i < values.Length; i++) {
            rlt[i] = new Vector2(values[i].x, flipUV ? 1 - values[i].y : values[i].y);
        }
        return rlt;
    }

    Color[] ToColorArray(Vector4[] values)
    {
        Color[] rlt = new Color[values.Length];
        for (int i = 0; i < values.Length; i++) {
            rlt[i] = values[i];
        }
        return rlt;
    }

    BoneWeight[] ToBoneWeights(int[,] indices, Vector4[] weights)
    {
        int blendNum = indices.GetLength(1);
        BoneWeight[] boneWeights = new BoneWeight[weights.Length];
        for(int i = 0; i< weights.Length; i++) {
            if(blendNum > 0) {
                boneWeights[i].boneIndex0 = (int)indices[i,0];
                boneWeights[i].weight0 = weights[i].x;
            }else if(blendNum > 1) {
                boneWeights[i].boneIndex1 = (int)indices[i,1];
                boneWeights[i].weight1 = weights[i].y;
            } else if(blendNum > 2) {
                boneWeights[i].boneIndex2 = (int)indices[i,2];
                boneWeights[i].weight2 = weights[i].z;
            } else {
                boneWeights[i].boneIndex3 = (int)indices[i,3];
                boneWeights[i].weight3 = weights[i].w;
            }
        }
        return boneWeights;
    }

    public Mesh ImportMesh()
    {
        Mesh mesh = new Mesh();
        mesh.name = "RipMesh";

        if(model.meshAttrIndex[0] != -1) {
            mesh.vertices = ToVector3Array(model.attributes[model.meshAttrIndex[0]].values,scale);
        }

        if(model.meshAttrIndex[1] != -1) {
            mesh.normals = ToVector3Array(model.attributes[model.meshAttrIndex[1]].values);
        }

        if(model.meshAttrIndex[2] != -1) {
            mesh.colors = ToColorArray(model.attributes[model.meshAttrIndex[2]].values);
        }

        if(model.meshAttrIndex[3] != -1) {
            mesh.uv = ToVector2Array(model.attributes[model.meshAttrIndex[3]].values,flipUV);
        }
        if (model.meshAttrIndex[4] != -1) {
            mesh.uv2 = ToVector2Array(model.attributes[model.meshAttrIndex[4]].values,flipUV2);
        }
        if (model.meshAttrIndex[5] != -1) {
            mesh.uv3 = ToVector2Array(model.attributes[model.meshAttrIndex[5]].values,false);
        }
        if (model.meshAttrIndex[6] != -1) {
            mesh.uv4 = ToVector2Array(model.attributes[model.meshAttrIndex[6]].values,false);
        }
        if(model.meshAttrIndex[7] != -1) {
            mesh.tangents = model.attributes[model.meshAttrIndex[7]].values;
        }
        if(model.meshAttrIndex[8] != -1 && model.meshAttrIndex[9] != -1) {
            mesh.boneWeights = ToBoneWeights(model.attributes[model.meshAttrIndex[8]].intValues, model.attributes[model.meshAttrIndex[9]].values);
        }

        if (!flipTriangle) {
            mesh.triangles = model.faces;
        } else {
            int[] indices = new int[model.faces.Length];
            for(int i =0; i<model.faces.Length/3; i++) {
                indices[i * 3 + 0] = model.faces[i * 3 + 0];
                indices[i * 3 + 1] = model.faces[i * 3 + 2];
                indices[i * 3 + 2] = model.faces[i * 3 + 1];
            }
            mesh.triangles = indices;
        }
        mesh.RecalculateBounds();
        if (recalculateNormal) {
            mesh.RecalculateNormals();
        }
        return mesh;
    }

    public void SaveMesh(Mesh mesh)
    {
        string path = ConvertToInternalPath(AssetDatabase.GetAssetPath(Selection.activeObject));
        AssetDatabase.CreateAsset(mesh, path);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    public static string ConvertToInternalPath(string asset)
    {
        string left = asset.Substring(0, asset.Length - extension.Length);
        return left + newExtension;
    }

    public static string GetParentPath(string asset)
    {
        int lastSep = asset.LastIndexOf("/");
        return asset.Substring(0, lastSep);
    }

    static string ReadString(BinaryReader bin)
    {
        List<char> chars = new List<char>();
        char c = bin.ReadChar();
        while (c != 0) {
            chars.Add(c);
            c = bin.ReadChar();
        }
        return new string(chars.ToArray());
    }

    RipModel ReadModel(BinaryReader bin)
    {
        RipModel model = new RipModel();
        model.signature = bin.ReadUInt32();
        model.version = bin.ReadUInt32();
        int facesCnt = bin.ReadInt32();
        int vertexesCnt = bin.ReadInt32();
        int vertexSize = bin.ReadInt32();
        int textureFilesCnt = bin.ReadInt32();
        int shaderFilesCnt = bin.ReadInt32();
        int vertexAttributesCnt = bin.ReadInt32();

        model.vertexesCnt = vertexesCnt;
        model.faces = new int[facesCnt * 3];
        model.textureFiles = new string[textureFilesCnt];
        model.shaderFiles = new string[shaderFilesCnt];
        model.attributes = new List<RipAttribute>();

        for (int i = 0; i < vertexAttributesCnt; i++) {
            RipAttribute attr = new RipAttribute();
            attr.semantic = ReadString(bin);
            attr.semanticIndex = bin.ReadInt32();
            attr.offset = bin.ReadInt32();
            attr.size = bin.ReadInt32();
            int elementCnt = bin.ReadInt32();//3
            attr.vertexAttribTypesArray = new int[elementCnt];
            for (int e = 0; e < elementCnt; e++) {
                int typeElement = bin.ReadInt32();
                attr.vertexAttribTypesArray[e] = typeElement;
            }
            model.attributes.Add(attr);
        }
        for (int t = 0; t < model.textureFiles.Length; t++) {
            model.textureFiles[t] = ReadString(bin);
        }
        for (int s = 0; s < model.shaderFiles.Length; s++) {
            model.shaderFiles[s] = ReadString(bin);
        }
        for (int f = 0; f < facesCnt; f++) {
            model.faces[f * 3 + 0] = bin.ReadInt32();
            model.faces[f * 3 + 1] = bin.ReadInt32();
            model.faces[f * 3 + 2] = bin.ReadInt32();
        }
        for (int a = 0; a < vertexAttributesCnt; a++) {
            model.attributes[a].values = new Vector4[vertexesCnt];
            model.attributes[a].intValues = new int[vertexesCnt,model.attributes[a].vertexAttribTypesArray.Length];
        }
        for (int v = 0; v < vertexesCnt; v++) {
            for (int a = 0; a < vertexAttributesCnt; a++) {
                if (model.attributes[a].vertexAttribTypesArray[0] == 0) {//float
                    float[] values = new float[4];
                    for (int i = 0; i < model.attributes[a].vertexAttribTypesArray.Length; i++) {
                        values[i] = bin.ReadSingle();
                    }
                    model.attributes[a].values[v] = new Vector4(values[0], values[1], values[2], values[3]);
                } else {//int
                    for (int i = 0; i < model.attributes[a].vertexAttribTypesArray.Length; i++) {
                        model.attributes[a].intValues[v,i] = bin.ReadInt32();
                    }
                }
            }
        }
        return model;
    }
}

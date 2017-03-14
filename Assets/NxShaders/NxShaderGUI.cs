using UnityEditor;
using UnityEngine;

public class NxShaderGUI : ShaderGUI
{
    public enum BlendMode
    {
        Opaque,
        Cutout,
        //Fade,       
        //Transparent         
    }

    MaterialProperty blendMode = null;
    public static readonly string[] blendNames = System.Enum.GetNames(typeof(BlendMode));

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        Material material = materialEditor.target as Material;
        EditorGUI.BeginChangeCheck();
        {
            blendMode = FindProperty("_Mode", properties);
            BlendModePopup(materialEditor);
            base.OnGUI(materialEditor, properties);
        }
        if (EditorGUI.EndChangeCheck()) {
            SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));
        }
    }

    void BlendModePopup(MaterialEditor materialEditor)
    {
        EditorGUI.showMixedValue = blendMode.hasMixedValue;
        var mode = (BlendMode)blendMode.floatValue;

        EditorGUI.BeginChangeCheck();
        mode = (BlendMode)EditorGUILayout.Popup("Rendering Mode", (int)mode, blendNames);
        if (EditorGUI.EndChangeCheck()) {
            materialEditor.RegisterPropertyChangeUndo("Rendering Mode");
            blendMode.floatValue = (float)mode;
        }

        EditorGUI.showMixedValue = false;
    }

    public static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode)
    {
        switch (blendMode) {
            case BlendMode.Opaque:
                material.SetOverrideTag("RenderType", "");
                material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                material.SetInt("_ZWrite", 1);
                material.DisableKeyword("ALPHA_TEST_ENABLE");
                material.DisableKeyword("_ALPHATEST_ON");
                material.DisableKeyword("_ALPHABLEND_ON");
                material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                material.renderQueue = -1;
                break;
            case BlendMode.Cutout:
                material.SetOverrideTag("RenderType", "TransparentCutout");
                material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                material.SetInt("_ZWrite", 1);
                material.EnableKeyword("ALPHA_TEST_ENABLE");
                material.EnableKeyword("_ALPHATEST_ON");
                material.DisableKeyword("_ALPHABLEND_ON");
                material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                break;
            //case BlendMode.Fade:
            //    material.SetOverrideTag("RenderType", "Transparent");
            //    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
            //    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
            //    material.SetInt("_ZWrite", 0);
            //    material.DisableKeyword("_ALPHATEST_ON");
            //    material.EnableKeyword("_ALPHABLEND_ON");
            //    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
            //    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
            //    break;
            //case BlendMode.Transparent:
            //    material.SetOverrideTag("RenderType", "Transparent");
            //    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
            //    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
            //    material.SetInt("_ZWrite", 0);
            //    material.DisableKeyword("_ALPHATEST_ON");
            //    material.DisableKeyword("_ALPHABLEND_ON");
            //    material.EnableKeyword("_ALPHAPREMULTIPLY_ON");
            //    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
            //    break;
        }
    }
}
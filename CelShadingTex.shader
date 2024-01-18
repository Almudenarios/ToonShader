Shader "Custom/CelShading"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1,1,1,1)
        _Shades("Shades", Range(1,20)) = 3
        _InkColor("InkColor", Color) = (0,0,0,0)
        _InkSize("InkSize", float) = 1.0
        _MainTexture("Main Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200



        Pass{
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _InkColor;
            float _InkSize;

            v2f vert(appdata v)
            {
                v2f o;
                //use normals to move vertex along making the model bigger

                o.vertex = UnityObjectToClipPos(v.vertex + _InkSize * v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                return _InkColor;
            }

                ENDCG
        }

        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD1;
                float3 worldNormal : TEXCOORD0;
            };

            sampler2D _MainTexture;

            float4 _Albedo;
            float _Shades;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // cos of normal and light direction
                //normalize light direction and calculate scalar
                // 
                float cosineAngle = dot(normalize(i.worldNormal), normalize(_WorldSpaceLightPos0.xyz));
                cosineAngle = max(cosineAngle, 0.0);

                //cuantizacion de tonos

                cosineAngle = floor(cosineAngle * _Shades) / _Shades;
                //sample the texture
                fixed4 textureColor = tex2D(_MainTexture, i.uv);

                
                // test uvs:
                //fixed4 col = fixed4(i.uv, 1, 1);
                //return col;

                //return _Albedo * cosineAngle;
                return textureColor * cosineAngle;
            }

                ENDCG
        }

    }
        Fallback "VertexLit"
}

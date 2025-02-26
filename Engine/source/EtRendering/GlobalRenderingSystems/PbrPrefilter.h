#pragma once


namespace et {
namespace render {


class PbrPrefilter final
{
public:
	void Precompute(int32 resolution);

	static void PrefilterCube(TextureData const* const source, 
		TextureData*& irradiance, 
		TextureData*& radiance, 
		int32 const resolution, 
		int32 const irradianceRes, 
		int32 const radianceRes);

	static void PopulateCubeTextureParams(render::TextureParameters& params);

	TextureData* GetLUT();
private:
	friend class RenderingSystems;

	PbrPrefilter();
	~PbrPrefilter();

	TextureData* m_LUT = nullptr;
};


} // namespace render
} // namespace et

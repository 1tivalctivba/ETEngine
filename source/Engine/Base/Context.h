#pragma once
#include <Engine/Helper/Singleton.h>
#include <Engine/Base/Time.h>
#include <Engine/Components/CameraComponent.h>
#include <Engine/SceneGraph/AbstractScene.h>


class ContextObjects
{
public:
	ContextObjects()
	{}
	 ~ContextObjects()
	{
	}
	Time* pTime;
	CameraComponent* pCamera;
	AbstractScene* pScene;
};

struct Context : public Singleton<Context>, public ContextObjects
{
public:
	Context():ContextObjects()
	{
	}
	~Context() 
	{ 
	}
	void SetContext(ContextObjects* pContext)
	{
		pTime = pContext->pTime;
		pCamera = pContext->pCamera;
		pScene = pContext->pScene;
	}
};

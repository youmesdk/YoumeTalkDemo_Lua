﻿//
//  IYouMeEventCallback.h
//  youme_voice_engine
//
//  Created by fire on 2016/12/14.
//  Copyright © 2016年 Youme. All rights reserved.
//

#ifndef IYouMeEventCallback_h
#define IYouMeEventCallback_h

#include "YouMeConstDefine.h"
#include <list>
#include <string>

class IYouMeEventCallback
{
public:
    virtual void onEvent(const YouMeEvent event, const YouMeErrorCode error, const char * channel, const char * param) = 0;
};

class IYouMePcmCallback
{
public:
    virtual void onPcmData(int channelNum, int samplingRateHz, int bytesPerSample, void* data, int dataSizeInByte) = 0;
};

class IRestApiCallback{
public:
    virtual void onRequestRestAPI( int requestID, const YouMeErrorCode &iErrorCode, const char* strQuery, const char*  strResult ) = 0;
};


struct MemberChange{
    const char* userID;
    bool isJoin;
};


class IYouMeMemberChangeCallback
{
public:
	virtual void onMemberChange( const char* channel, const char* listMemberChange , bool bUpdate ) = 0 ;
};


class IYouMeChannelMsgCallback
{
public:
	virtual void onBroadcast(const YouMeBroadcast bc, const char* channel, const char* param1, const char* param2, const char* strContent) = 0;
};


#endif /* IYouMeEventCallback_h */

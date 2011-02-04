/*
 *  NetworkConstants.h
 *  BallStack
 *
 *  Created by Adam McDonald on 11/25/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#define SERVER_IP @"0.0.0.0"
//#define SERVER_IP @"198.145.40.124"
#define SERVER_PORT 1234

#define BSMESSAGE_TYPE_INDEX 0

#define BSMESSAGE_FAILURE -1

#define BSMESSAGE_JOINGAME_GAMEID_INDEX 1
#define BSMESSAGE_JOINGAME_TITLE_INDEX 2
#define BSMESSAGE_JOINGAME_SECONDSUNTILSTART_INDEX 3
#define BSMESSAGE_JOINGAME_MAXPLAYERS_INDEX 4
#define BSMESSAGE_JOINGAME_JOINEDPLAYERS_INDEX 5
#define BSMESSAGE_JOINGAME_PLAYERS_INDEX 6
#define BSMESSAGE_CREATEGAME_GAMEID_INDEX 1
#define BSMESSAGE_CREATEGAME_SECONDSUTILSTART_INDEX 2
#define BSMESSAGE_LISTGAMES_TUPLE_SIZE 5
#define BSMESSAGE_STATUSUPDATE_PLAYERID_INDEX 1
#define BSMESSAGE_STATUSUPDATE_STATUS_INDEX 2
#define BSMESSAGE_POWERUPUSAGE_TYPE_INDEX 1
#define BSMESSAGE_PLAYERJOIN_PLAYERID_INDEX 1
#define BSMESSAGE_PLAYERLEFT_PLAYERID_INDEX 1
#define BSMESSAGE_JOINGAME_ADDTIME_SECONDS_INDEX 1

typedef enum {
	BSMessageUnknown,
	BSMessageJoinGame,
	BSMessageLeaveGame,
	BSMessageListGames,
	BSMessageCreateGame,
	BSMessageStatusUpdate,
	BSMessagePowerupUsage,
	BSMessagePlayerJoin,
	BSMessagePlayerLeft,
	BSMessageStartGame,
	BSMessageAddTime,
	BSMessageRandomGame,
} BSMessage;
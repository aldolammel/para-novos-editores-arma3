// include the few macros we use ...
#include <T8\MACRO.hpp>

// wait until everything is initalized correctly
waitUntil { !isNil "T8U_var_useHC" };
waitUntil { !isNil "T8U_var_InitDONE" };

// cancel execute if not server / hc
__allowEXEC(__FILE__);


sleep 5;

//////////////////////////////////////  CUSTOM FUNCTION  //////////////////////////////////////
//
//			This function is called for every unit in a group 
//			where it is defined in the groups definiton below
//

T8u_fnc_rmNVG = 
{
	_this spawn
	{
		sleep 5;
	
		private ["_i"];
		_i = true;
		switch ( side _this ) do 
		{ 
			case WEST:			{ _this unlinkItem "NVGoggles"; _this unlinkItem "ItemWatch"; _this unlinkItem "ItemCompass"; _this unlinkItem "ItemRadio"; _this unlinkItem "ItemGPS"; _this unlinkItem "ItemMap"; _this removeWeapon "Binocular"; };
			case EAST:			{ _this unlinkItem "NVGoggles_OPFOR"; _this unlinkItem "ItemWatch"; _this unlinkItem "ItemCompass"; _this unlinkItem "ItemRadio"; _this unlinkItem "ItemGPS"; _this unlinkItem "ItemMap"; _this removeWeapon "Binocular"; };
			case RESISTANCE:	{ _this unlinkItem "NVGoggles_INDEP"; _this unlinkItem "ItemWatch"; _this unlinkItem "ItemCompass"; _this unlinkItem "ItemRadio"; _this unlinkItem "ItemGPS"; _this unlinkItem "ItemMap"; _this removeWeapon "Binocular"; };
			default				{ _i = false; };
		};
		
		if ( _i ) then 
		{
			_this removePrimaryWeaponItem "acc_pointer_IR";
			_this addPrimaryWeaponItem "acc_flashlight";
		};
			
		sleep 1;
		group _this enableGunLights "forceon";
	};
};

//////////////////////////////////////  UNIT SETUP  //////////////////////////////////////

// Aqui você devine quais soldados (e de qual mod se vc estiver usando mods) devem ser spawnados. Repare que há antes dos grupos de soldados uma variável que representa a função daqueles soldados. Vc tem total liberdade de pôr quais e quantos soldados quiser em cada uma destas variáveis. Vc pode até mesmo criar outras variáveis embora eu não recomende: 
_FULLSquad = 		[ "O_Soldier_SL_F", "O_Soldier_AAR_F", "O_Soldier_AR_F", "O_Soldier_M_F", "O_medic_F", "O_Soldier_GL_F", "O_Soldier_GL_F", "O_Soldier_F", "O_Soldier_F" ];
_INFRegular = 		[ "O_Soldier_SL_F", "O_medic_F", "O_Soldier_AR_F", "O_Soldier_F", "O_Soldier_F" ];
_INFTiny = 			[ "O_Soldier_SL_F", "O_Soldier_F", "O_Soldier_F" ];
_MGTeam1 = 			[ "O_Soldier_AR_F", "O_Soldier_AAR_F" ];
_MGTeam2 = 			[ "O_HeavyGunner_F", "O_Soldier_AAR_F" ];
_ATTeam = 			[ "O_Soldier_LAT_F", "O_Soldier_F" ];
_GLTeam = 			[ "O_Soldier_GL_F", "O_Soldier_GL_F" ];
_SNIPERTeam = 		[ "O_Soldier_M_F", "O_Soldier_F" ];
_VECTeamLight1 = 	[];
_VECTeamLight2 = 	[];
_VECTeamMedium1 = 	[];
_VECTeamMedium2 = 	[];
_VECTeamHeavy1 =  	[];
_VECTeamHeavy2 =  	[];
_PARATeam = 		[ "O_soldier_PG_F", "O_soldier_PG_F" ];

// ABaixo é a configuração da equipe de ajuda. Quando seu inimigo (EAST neste caso) estiver no sufoco, ele pedirá ajuda aos seus paraquedistas quando disponíveis (existe um cooldown para esse recurso não ser pedido a todo instante). Vamos lá:
T8U_var_SupportUnitsEAST = 			[ _PARATeam, _PARATeam ];
T8U_var_SupportUnitsWEST = 			[];
T8U_var_SupportUnitsRESISTANCE = 	[];


// O Spawn_A é responsável pelas unidades que spawnaram com o início da partida. Importante: sempre que você adicionar a última linha de unidade a spawnar, não pode haver vírgula. Repare que a linha do grupo _MGTeam1 não possui vírgula final. Veja no Spawn_B e Spawn_C que suas últimas linhas tb não tem. Se vc esquecer uma vírgula ali, dará erro. Ok? Fique atento:
Spawn_A = 
[
	[ [ _MGTeam1, "zona01" 			], [ "DEFEND" 			], [ true, true, false ]],
	[ [ _FULLSquad, "zona01" 		], [ "GARRISON" 		], [ true, false, true ]],
	[ [ _GLTeam, "zona01" 			], [ "PATROL" 			], [ true, true, true ]]
];

[ Spawn_A ] spawn T8U_fnc_Spawn;

// O Spwan_B ou C, D, etc, referece às unidades que spawnaram assim que o player se aproximar de uma zona. Repare que vc pode mandar novas unidades nascerem não apenas em novas zonas mas também em zonas que já sofreram spawn como no caso da zona01. Quando vc pensar em Spawn_B por exemplo, pense que a melhor tradução para isso seja 'leva' ou 'onda'. O Spawn_B é a segunda leva/onda de inimigos. O Spawn_C é a terceira onda e assim por diante:
Spawn_B = 
[
	[ [ _MGTeam2, "zona01" 			], [ "DEFEND" 			], [ true, true, false ]],
	[ [ _SNIPERTeam, "zona01" 		], [ "OVERWATCH" 		], [ false, false, false ]],
	[ [ _FULLSquad, "zona02" 		], [ "GARRISON" 		], [ true, false, true ]],
	[ [ _INFTiny, "zona02" 			], [ "OCCUPY", true 	], [ true, false, true ]],
	[ [ _GLTeam, "zona02" 			], [ "PATROL" 			], [ true, false, true ]]
];	

Spawn_C =
[
	[ [ _FULLSquad, "zona03" 		], [ "PATROL" 			], [ true, false, true ]],
	[ [ _INFTiny, "zona03" 			], [ "OCCUPY", true 	], [ true, false, true ]],
	[ [ _INFTiny, "zona04" 			], [ "PATROL" 			], [ true, true, true ]],
	[ [ _ATTeam, "zona04" 			], [ "OCCUPY", true 	], [ true, false, true ]]
];	

// Abaixo é a configuração da zona(s) que spawnaram(ão) inimigos com a aproximação dos players. Repare que vc pode determinar qual será a zona que será o gatilho para o novo Spawn de inimigos além de configurar a distância-limite para o spawn ser disparado;
// [ _unitsArray, _marker, _distance, _condition, _actSide, _actType, _actRepeat, _onAct, _onDeAct ] call T8U_fnc_TriggerSpawn;
[ "Spawn_B", "zona02", 108, "this", "WEST", "PRESENT", false, "", "" ] call T8U_fnc_TriggerSpawn;
[ "Spawn_C", "zona01", 100, "this", "WEST", "PRESENT", false, "", "" ] call T8U_fnc_TriggerSpawn;


// Caso vc queira um T8 que não seja ativado por aproximação e sim por uma trigger, vá no Workshop e assine minha missão SHARIA EM RAQQA onde eu adaptei este script para funcionar com trigger.

// THE END ---------------------------------------------------
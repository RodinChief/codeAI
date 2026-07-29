---@meta

---@class ABlamCinematicCamera : ACineCameraActor
---@field FollowSettings FCameraFollowSettings
local ABlamCinematicCamera = {}



---@class ABlamDebugRenderActor : AActor
---@field LineListComponent UBlamDebugMeshComponent
---@field TriangleListComponent UBlamDebugMeshComponent
---@field DefaultFont UFont
local ABlamDebugRenderActor = {}



---@class ABlamGameMode : AHaloModularGameModeBase
---@field InsertionPointStartSpot TWeakObjectPtr<AActor>
local ABlamGameMode = {}

---@param GAMEMODE AGameModeBase
---@param NewController AController
function ABlamGameMode:OnGameModePlayerInitialized__DelegateSignature(GAMEMODE, NewController) end


---@class ABlamGameModePlayerStart : ANavigationObjectBase
---@field InsertionPointName FString
local ABlamGameModePlayerStart = {}



---@class ABlamGameState : AHaloModularGameStateBase
---@field IncidentHandlerComponentClass TSubclassOf<UActorComponent>
---@field IncidentHandlerComponent UActorComponent
---@field BlamCampaignFlowComponent UBlamCampaignFlowGameStateComponent
---@field BlamNetworkGameStateComponent UBlamNetworkGameStateComponent
---@field BlamSkullsGameStateComponent UBlamSkullsGameStateComponent
---@field ExperienceManagerComponent UBlamExperienceManagerComponent
local ABlamGameState = {}



---@class ABlamHUD : AHUD
local ABlamHUD = {}


---@class ABlamPawn : AHaloModularPawn
---@field OnFirstPersonStateChanged FBlamPawnOnFirstPersonStateChanged
---@field OnFirstPersonOverlayChanged FBlamPawnOnFirstPersonOverlayChanged
---@field OnUnitChanged FBlamPawnOnUnitChanged
---@field OnMovingChanged FBlamPawnOnMovingChanged
---@field OnCameraPerspectiveChanged FBlamPawnOnCameraPerspectiveChanged
---@field FirstPersonState EBlamFirstPersonWeaponState
---@field FirstPersonStateAnimationName FName
---@field FirstPersonOverlay EBlamFirstPersonWeaponOverlay
---@field FirstPersonOverlayAnimationName FName
---@field bPlayerIsMoving boolean
---@field CurrentBlamCameraPerspective EBlamCameraPerspective
---@field PlayerCrouchLevel float
---@field CameraComponent UCameraComponent
---@field DefaultSceneComponent USceneComponent
---@field ArmsMeshSynchronizationComponent UBlamMeshSynchronizationComponent
---@field LegsMeshSynchronizationComponent UBlamMeshSynchronizationComponent
---@field SkeletonSynchronizationComponent UBlamSkeletonSynchronizationComponent
---@field FirstPersonWeaponSocketAttachmentName FName
local ABlamPawn = {}

---@param PreviousUnitActor AActor
---@param UnitActor AActor
function ABlamPawn:OnUnitChanged__DelegateSignature(PreviousUnitActor, UnitActor) end
---@param PreviousState EBlamFirstPersonWeaponState
---@param PreviousAnimationName FName
---@param NewState EBlamFirstPersonWeaponState
---@param NewAnimationName FName
function ABlamPawn:OnStateChanged__DelegateSignature(PreviousState, PreviousAnimationName, NewState, NewAnimationName) end
---@param PreviousOverlay EBlamFirstPersonWeaponOverlay
---@param PreviousAnimationName FName
---@param NewOverlay EBlamFirstPersonWeaponOverlay
---@param NewAnimationName FName
function ABlamPawn:OnOverlayChanged__DelegateSignature(PreviousOverlay, PreviousAnimationName, NewOverlay, NewAnimationName) end
function ABlamPawn:OnMovingChanged__DelegateSignature() end
function ABlamPawn:OnCameraPerspectiveChanged__DelegateSignature() end
---@param OutViewMode EBlamCameraPerspective
---@param ThirdPersonWeapon AActor
---@param FirstPersonWeapon AActor
function ABlamPawn:GetPawnViewModeAndWeaponActors(OutViewMode, ThirdPersonWeapon, FirstPersonWeapon) end
---@return UClass
function ABlamPawn:GetEquippedWeaponClass() end
---@return AActor
function ABlamPawn:GetBlamObjectActor() end


---@class ABlamPlayerController : AHaloModularPlayerController
local ABlamPlayerController = {}

---@param PreviousPlayerActor AActor
---@param NewPlayerActor AActor
function ABlamPlayerController:OnUnitChanged(PreviousPlayerActor, NewPlayerActor) end
---@param Reason ESessionLeaveReason
function ABlamPlayerController:ClientSetPendingSessionLeaveReason(Reason) end


---@class ABlamPlayerState : AHaloModularPlayerState
---@field BlamExperiencePlayerStateComponent UBlamExperiencePlayerStateComponent
---@field BlamNetworkPlayerStateComponent UBlamNetworkPlayerStateComponent
---@field BlamPlayerStateComponent UBlamPlayerStateComponent
---@field HaloPrivilegePlayerStateComponent UHaloPrivilegePlayerStateComponent
local ABlamPlayerState = {}



---@class ABlamScenario : AActor
---@field ScenarioName FString
---@field ScenarioDataLayers FDataLayerSelector
---@field ScenarioScripts TArray<FFilePath>
---@field bIncludeActorsNotInLayers boolean
---@field Type EScenarioTypeEnum
---@field Flags FScenarioFlags
---@field CampaignId int32
---@field MapId int32
---@field MAPNAME FString
---@field SoundPermutationMissionId int16
---@field LocalNorth float
---@field LocalSeaLevel float
---@field AltitudeCap float
---@field SandboxOriginPoint FVector3f
---@field SandboxBudget float
---@field DefaultVehicleSet FString
---@field PlayerAppearanceCustomizations FBlamScenarioPlayerAppearanceCustomization
---@field GamePerformanceThrottles TSoftObjectPtr<UBlamGamePerformanceThrottleTagDataAsset>
---@field MultiplayerObjectTypes TSoftObjectPtr<UBlamMultiplayerObjectTypeListTagDataAsset>
---@field AirStrike TSoftObjectPtr<UBlamAirstrikeTagDataAsset>
---@field AiStyle TArray<TSoftObjectPtr<UBlamStyleTagDataAsset>>
---@field MissionDialogue TSoftObjectPtr<UBlamAiMissionDialogueTagDataAsset>
---@field CutsceneChapterTitles TArray<FScenarioCutsceneTitle>
---@field ChapterTitleText TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset>
---@field Subtitles TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset>
---@field Objectives TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset>
---@field UserInterfaceObjectivesDataAsset UScenarioUserInterfaceObjectiveAsset
---@field Interpolators TSoftObjectPtr<UBlamScenarioInterpolatorTagDataAsset>
---@field PerformanceThrottles TSoftObjectPtr<UBlamPerformanceThrottlesTagDataAsset>
---@field OverridePlayerRepresentations TArray<FGameGlobalsPlayerRepresentation>
---@field LocationNameGlobals TSoftObjectPtr<UBlamLocationNameGlobalsDefinitionTagDataAsset>
---@field ChudReference TSoftObjectPtr<UBlamChudDefinitionTagDataAsset>
---@field RequiredResources TSoftObjectPtr<UBlamScenarioRequiredResourceTagDataAsset>
---@field CampaignMetagame FCampaignMetagameScenario
---@field SoftCeilings TArray<FScenarioSoftCeiling>
---@field InsertionPointsDataAsset UScenarioInsertionPointAsset
---@field InsertionPoints TArray<FScenarioInsertionPoint>
---@field WeaponSpawnInfluencers TArray<FWeaponSpawnInfluence>
---@field VehicleSpawnInfluencers TArray<FVehicleSpawnInfluence>
---@field ProjectileSpawnInfluencers TArray<FProjectileSpawnInfluence>
---@field EquipmentSpawnInfluencers TArray<FEquipmentSpawnInfluence>
---@field StructureSeams FString
---@field StructureBsps TArray<FScenarioStructureBspReference>
---@field StructureDesigns TArray<FScenarioStructureDesignReference>
---@field ZoneSets TArray<FScenarioZoneSet>
---@field Cinematics TArray<FScenarioCinematicReference>
---@field EncounterRemix TSoftObjectPtr<UBlamEncounterRemixTagDataAsset>
local ABlamScenario = {}



---@class ABlamWorldSettings : AWorldSettings
---@field DefaultScenario TSoftObjectPtr<ABlamScenario>
---@field DefaultBlamExperience TSoftClassPtr<UBlamExperienceDefinition>
local ABlamWorldSettings = {}

---@param Components TArray<UActorComponent>
---@param bDetachSceneComponentsFirst boolean
---@return int32
function ABlamWorldSettings:DestroyComponents(Components, bDetachSceneComponentsFirst) end


---@class AFrontendGameMode : AHaloModularGameModeBase
local AFrontendGameMode = {}


---@class FBlamAchievementDefinition
---@field AchievementId FName
---@field bRequireIncidentCausePlayer boolean
---@field bRequireIncidentEffectPlayer boolean
---@field RequiredUnrealLevel TSoftObjectPtr<UWorld>
---@field RequiredBlamScenarioName FString
---@field RepeatCount int32
---@field TriggeringIncidents TArray<FBlamIncidentName>
---@field bAnyIncidentGeneratesProgress boolean
---@field bBlockedByDifficultyModifiers boolean
---@field bBlockedInRemix boolean
---@field BlockerActiveSkulls FGameplayTagContainer
---@field RequiredActiveSkulls FGameplayTagContainer
---@field RequiredUnlockedProgresionGamplayTags FGameplayTagContainer
local FBlamAchievementDefinition = {}



---@class FBlamCustomMapping
---@field Action EBlamInputAction
---@field Key FKey
---@field BindingSlot EBlamKeyBindingSlot
---@field InputDevice EBlamInputDeviceType
local FBlamCustomMapping = {}



---@class FBlamCustomMappingContext
---@field SettingsSaveVersion int32
---@field BasePresetName FName
---@field CustomMappings TArray<FBlamCustomMapping>
local FBlamCustomMappingContext = {}



---@class FBlamHapticsEventHandle
---@field InternalId uint32
local FBlamHapticsEventHandle = {}



---@class FBlamIncident
---@field Name FName
---@field CauseObjectActor AActor
---@field CausePlayerAbsoluteIndex int32
---@field EffectObjectActor AActor
---@field EffectPlayerAbsoluteIndex int32
---@field DamageReportingInfo FBlamDamageReportingInfo
---@field CustomString FString
---@field CustomValue int32
local FBlamIncident = {}



---@class FBlamIncidentNameToMissionCompletionProgress
---@field IncidentToProgressMap TMap<FName, FBlamMissionsDifficultyProgress>
---@field RemixIncidentToProgressMap TMap<FName, FBlamMissionsDifficultyProgress>
---@field LASOIncidentToProgressMap TMap<FName, FBlamMissionsDifficultyProgress>
local FBlamIncidentNameToMissionCompletionProgress = {}



---@class FBlamIncidentNameToProgressMap
---@field Map TMap<FName, FBlamIncidentProgress>
local FBlamIncidentNameToProgressMap = {}



---@class FBlamIncidentProgress
---@field bMustBeCausePlayer boolean
---@field bMustBeEffectPlayer boolean
---@field ProgressGameplayTag FGameplayTag
local FBlamIncidentProgress = {}



---@class FBlamInputPreset
---@field PresetName FName
---@field BasePresetName FName
---@field bIsFixed boolean
---@field MappingContext UInputMappingContext
local FBlamInputPreset = {}



---@class FBlamMissionsDifficultyProgress
---@field ScenarioNameToGameplayTagMap TMap<FString, FGameplayTag>
local FBlamMissionsDifficultyProgress = {}



---@class FBlamPlayerEffect
---@field LocalPlayerIndex int32
---@field DamageOwner FBlamDamageOwner
---@field Origin FVector
---@field DamageScale float
---@field NormalizedBodyDamage float
---@field NormalizedShieldDamage float
---@field NormalizedTotalDamage float
---@field Flags FBlamPlayerEffectFlags
---@field DataAsset UObject
local FBlamPlayerEffect = {}



---@class FBlamRenderSettingsChangeData
local FBlamRenderSettingsChangeData = {}


---@class FBlamSavedActorComponentRecord
---@field Class TSoftClassPtr<UActorComponent>
---@field bIsDefaultComponent boolean
---@field ComponentName FString
local FBlamSavedActorComponentRecord = {}



---@class FBlamSavedActorRecord
---@field Class TSoftClassPtr<AActor>
---@field BlamObjectGameStateIdentifier int16
---@field Components TArray<FBlamSavedActorComponentRecord>
---@field Name FString
local FBlamSavedActorRecord = {}



---@class FBlamScenarioDataTableRow : FTableRowBase
---@field UnrealLevel TSoftObjectPtr<UWorld>
---@field ScenarioName FString
---@field MapGuid FGuid
---@field MissionTitle FText
---@field MissionDescription FText
---@field MissionPreviewImage TSoftObjectPtr<UTexture2D>
---@field InsertionPointsDataAsset UScenarioInsertionPointAsset
---@field ProgressionUnlockTag FGameplayTag
local FBlamScenarioDataTableRow = {}



---@class FBlamScenarioGameOptions
---@field bLoadFromCoreSave boolean
---@field SaveSlot uint8
---@field SavedFilmName FString
---@field CampaignDifficultyLevel EBlamCampaignDifficultyLevel
---@field InsertionPoint int32
---@field ActiveSkulls TSet<EBlamGameSkulls>
---@field bFriendlyFireEnabled boolean
---@field bIsLASO boolean
---@field GameVariant UBlamGameEngineBaseVariant
local FBlamScenarioGameOptions = {}



---@class FBlamScenarioPlayerAppearanceCustomization
---@field VariantName FString
local FBlamScenarioPlayerAppearanceCustomization = {}



---@class FBlamUnrealSavedState
---@field SavedActors TArray<FBlamSavedActorRecord>
local FBlamUnrealSavedState = {}



---@class FCameraFollowSettings
---@field ActorToFollow TSoftObjectPtr<AActor>
---@field RelativeOffset FVector
---@field bFollowEnabled boolean
local FCameraFollowSettings = {}



---@class FCampaignMetagameScenario
---@field ParScore float
---@field TimeBonuses TArray<FCampaignMetagameScenarioCompletionBonus>
local FCampaignMetagameScenario = {}



---@class FCampaignMetagameScenarioCompletionBonus
---@field Time float
---@field ScoreMultiplier float
local FCampaignMetagameScenarioCompletionBonus = {}



---@class FColorSlotData
---@field ActiveColor FColor
---@field TransitionTime float
---@field TransitionCurve UCurveFloat
---@field SlotDuration float
local FColorSlotData = {}



---@class FDataLayerSelector
---@field DataLayerAssets TSet<TSoftObjectPtr<UDataLayerAsset>>
local FDataLayerSelector = {}



---@class FEquipmentSpawnInfluence
---@field Equipment TSoftObjectPtr<UBlamEquipmentTagDataAsset>
---@field Weight float
local FEquipmentSpawnInfluence = {}



---@class FGameGlobalsPlayerRepresentation
---@field Flags FPlayerRepresentationFlags
---@field ChudReference TSoftObjectPtr<UBlamChudDefinitionTagDataAsset>
---@field FirstPersonHands TSoftObjectPtr<UBlamRenderModelTagDataAsset>
---@field FirstPersonBody TSoftObjectPtr<UBlamRenderModelTagDataAsset>
---@field ThirdPersonUnit TSoftObjectPtr<UBlamUnitTagDataAsset>
---@field ThirdPersonVariant FString
---@field IntrinsicEquipment TSoftObjectPtr<UBlamEquipmentTagDataAsset>
---@field BinocularsZoomInSound TSoftObjectPtr<UBlamBaseSoundTagDataAsset>
---@field BinocularsZoomOutSounds TSoftObjectPtr<UBlamBaseSoundTagDataAsset>
local FGameGlobalsPlayerRepresentation = {}



---@class FGamepadLightEventData
---@field EventId FName
---@field EventType EGamepadLightEventType
---@field ColorSequence TArray<FColorSlotData>
---@field Priority int32
---@field bStopTrigger boolean
---@field EventToStop FName
local FGamepadLightEventData = {}



---@class FHaloMaterialResponseData
---@field ResponseTag FGameplayTag
---@field Forward FVector
---@field ImpactPoint FVector
---@field ImpactNormal FVector
---@field ImpactingObject TWeakObjectPtr<AActor>
---@field ImpactedObject TWeakObjectPtr<AActor>
---@field PhysMaterial TWeakObjectPtr<UPhysicalMaterial>
---@field ImpactedBoneName FName
---@field ImpactingBoneName FName
---@field ImpactingTag TWeakObjectPtr<UBlamTagDataAssetBase>
---@field ImpactedTag TWeakObjectPtr<UBlamTagDataAssetBase>
---@field SurfaceGameplayTag FGameplayTag
local FHaloMaterialResponseData = {}



---@class FHaloPhysicalMaterialToGameplayTagRow : FTableRowBase
---@field Material TSoftObjectPtr<UPhysicalMaterial>
---@field Tag FGameplayTag
local FHaloPhysicalMaterialToGameplayTagRow = {}



---@class FInputMapperOutputErrorData
---@field ExclusivityErrorAction EBlamInputAction
---@field ExclusivityErrorSlot EBlamKeyBindingSlot
local FInputMapperOutputErrorData = {}



---@class FPlayerRepresentationFlags
---@field bCanUseHealthPacks boolean
local FPlayerRepresentationFlags = {}



---@class FProjectileSpawnInfluence
---@field Projectile TSoftObjectPtr<UBlamProjectileTagDataAsset>
---@field LeadTime float
---@field CollisionCylinderRadius float
---@field Weight float
local FProjectileSpawnInfluence = {}



---@class FScenarioCinematicReference
---@field Flags FScenarioCinematicsFlags
---@field Cinematic TSoftObjectPtr<UBlamCinematicTagDataAsset>
local FScenarioCinematicReference = {}



---@class FScenarioCinematicsFlags
---@field bDebugOnly boolean
local FScenarioCinematicsFlags = {}



---@class FScenarioCutsceneTitle
---@field Name FString
---@field DelayedName2 FString
---@field DelayedName3 FString
---@field TransitionType EScenarioCutsceneTitleTransitionType
local FScenarioCutsceneTitle = {}



---@class FScenarioFlags
---@field bDontStripPathfinding boolean
---@field bQuickLoadingCinematicOnlyScenario boolean
---@field bCharactersUsePreviousMissionWeapons boolean
---@field bSnapToWhiteAtStart boolean
---@field bBigVehicleUseCenterPointForLightSampling boolean
---@field bDontUseCampaignSharing boolean
---@field bIgnoreSizeAndCanTShip boolean
---@field bInSpace boolean
---@field bSurvival boolean
---@field bDoNotStripVariants boolean
local FScenarioFlags = {}



---@class FScenarioInsertionPoint
---@field Name FString
---@field ZoneSetString FString
---@field Guid FGuid
---@field Title FText
---@field Description FText
---@field PreviewImage TSoftObjectPtr<UTexture2D>
---@field ProgressionUnlockTag FGameplayTag
---@field bRemoveFromShippingBuilds boolean
local FScenarioInsertionPoint = {}



---@class FScenarioSoftCeiling
---@field Name FString
---@field Flags FScenarioSoftCeilingFlagsDefinition
---@field Type ESoftCeilingTypeEnum
local FScenarioSoftCeiling = {}



---@class FScenarioSoftCeilingFlagsDefinition
---@field bIgnoreBipeds boolean
---@field bIgnoreVehicles boolean
---@field bIgnoreCamera boolean
---@field bIgnoreHugeVehicles boolean
local FScenarioSoftCeilingFlagsDefinition = {}



---@class FScenarioStructureBspReference
---@field StructureBsp FString
---@field StructureLightingInfo FString
---@field Flags FScenarioStructureBspReferenceFlagsDefinition
---@field CustomGravityScale float
local FScenarioStructureBspReference = {}



---@class FScenarioStructureBspReferenceFlagsDefinition
---@field bNoPathfinding boolean
---@field bNotANormallyPlayableSpaceInAnMPMapCheckThisOnSharedBSPs boolean
---@field bCustomGravityScale boolean
---@field bNoDefaultStructurePathfinding boolean
local FScenarioStructureBspReferenceFlagsDefinition = {}



---@class FScenarioStructureDesignReference
---@field StructureDesign FString
local FScenarioStructureDesignReference = {}



---@class FScenarioUserInterfaceObjective
---@field Name FString
local FScenarioUserInterfaceObjective = {}



---@class FScenarioZoneSet
---@field Name FString
---@field NameString FString
---@field Flags FScenarioZoneSetFlagsDefinition
---@field BspZoneFlags FString
---@field StructureDesignZoneFlags FString
local FScenarioZoneSet = {}



---@class FScenarioZoneSetFlagsDefinition
---@field bBeginLoadingNextLevel boolean
---@field bDebugPurposesOnly boolean
local FScenarioZoneSetFlagsDefinition = {}



---@class FVehicleSpawnInfluence
---@field Vehicle TSoftObjectPtr<UBlamVehicleTagDataAsset>
---@field PillRadius float
---@field LeadTime float
---@field MinimumVelocity float
---@field Weight float
local FVehicleSpawnInfluence = {}



---@class FWeaponSpawnInfluence
---@field Weapon TSoftObjectPtr<UBlamWeaponTagDataAsset>
---@field FullWeightRange float
---@field FallOffRange float
---@field FallOffConeRadius float
---@field Weight float
local FWeaponSpawnInfluence = {}



---@class IBlamGameUserSettingsValidation : IInterface
local IBlamGameUserSettingsValidation = {}

---@param CustomizationNames TArray<FGameplayTag>
---@return boolean
function IBlamGameUserSettingsValidation:ValidateCustomization(CustomizationNames) end


---@class IBlamSaveGameEventInterface : IInterface
local IBlamSaveGameEventInterface = {}

function IBlamSaveGameEventInterface:PreActorSerialize() end
function IBlamSaveGameEventInterface:OnStateRestoredFromSaveGame() end
function IBlamSaveGameEventInterface:OnBlamMapResetEvent() end


---@class IBlamScenarioActor : IInterface
local IBlamScenarioActor = {}


---@class UBlamAchievementListDataAsset : UDataAsset
---@field Achievements TArray<FBlamAchievementDefinition>
local UBlamAchievementListDataAsset = {}



---@class UBlamAchievementLocalPlayerSubsystem : UBlamIncidentHandlerLocalPlayerSubsystem
local UBlamAchievementLocalPlayerSubsystem = {}


---@class UBlamAcousticPortalBreakableSurfaceComponent : UHaloAudioPortalDoorComponent
---@field BreakableSurfaceTemplateGuid FGuid
---@field MaxProximity double
local UBlamAcousticPortalBreakableSurfaceComponent = {}



---@class UBlamAcousticPortalComponent : UHaloAudioPortalDoorComponent
---@field ScenarioObjectIdentifier int32
---@field bInvertedOpenDirection boolean
local UBlamAcousticPortalComponent = {}

---@param PreviousPositionFraction float
---@param PositionFraction float
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UBlamAcousticPortalComponent:OnDevicePositionFractionChanged(PreviousPositionFraction, PositionFraction, BlamPropertyChangeReason) end


---@class UBlamBreakableSurfaceSaveGame : UBlamSaveGame
local UBlamBreakableSurfaceSaveGame = {}


---@class UBlamBreakableSurfaceSaveGameSubsystem : UWorldSubsystem
local UBlamBreakableSurfaceSaveGameSubsystem = {}


---@class UBlamBuiltInMapInfoDataAsset : UPrimaryDataAsset
---@field CampaignInfos TArray<UBlamCampaignDataAsset>
---@field CampaignMapInfoTables TArray<UDataTable>
local UBlamBuiltInMapInfoDataAsset = {}



---@class UBlamCampaignDataAsset : UDataAsset
---@field CampaignGuid FGuid
---@field ScenarioList TArray<FDataTableRowHandle>
---@field CampaignType EBlamCampaignType
local UBlamCampaignDataAsset = {}



---@class UBlamCampaignFlowGameStateComponent : UGameStateComponent
---@field ActiveCampaign UBlamCampaignDataAsset
---@field bIsInLASO boolean
local UBlamCampaignFlowGameStateComponent = {}

function UBlamCampaignFlowGameStateComponent:OnRep_ActiveCampaign() end


---@class UBlamCampaignFlowGameSubsystem : UGameInstanceSubsystem
---@field CurrentCampaign UBlamCampaignDataAsset
local UBlamCampaignFlowGameSubsystem = {}

---@param Campaign UBlamCampaignDataAsset
---@param StartingScenarioName FName
---@param Options FBlamScenarioGameOptions
---@return boolean
function UBlamCampaignFlowGameSubsystem:SetAndBeginCampaign(Campaign, StartingScenarioName, Options) end
---@param Campaign UBlamCampaignDataAsset
function UBlamCampaignFlowGameSubsystem:SetActiveCampaign(Campaign) end
function UBlamCampaignFlowGameSubsystem:RevertToLastSave() end
function UBlamCampaignFlowGameSubsystem:RestartLevel() end
function UBlamCampaignFlowGameSubsystem:LeaveGame() end
---@return FName
function UBlamCampaignFlowGameSubsystem:GetLastBlamErrorName() end
function UBlamCampaignFlowGameSubsystem:EndCampaign() end
---@param StartingScenarioName FName
---@param Options FBlamScenarioGameOptions
---@return boolean
function UBlamCampaignFlowGameSubsystem:BeginCampaign(StartingScenarioName, Options) end
function UBlamCampaignFlowGameSubsystem:AcknowledgeLastBlamError() end


---@class UBlamCinematicSubsystem : UBlamGameInstanceSubsystem
---@field OnCinematicInProgress FBlamCinematicSubsystemOnCinematicInProgress
---@field OnCinematicBegin FBlamCinematicSubsystemOnCinematicBegin
---@field OnCinematicEnd FBlamCinematicSubsystemOnCinematicEnd
---@field LevelSequenceActor ALevelSequenceActor
local UBlamCinematicSubsystem = {}

---@param ShowSubtitleData FHaloUIShowSubtitle
function UBlamCinematicSubsystem:OnSubtitleShown(ShowSubtitleData) end
---@param bInProgress boolean
function UBlamCinematicSubsystem:OnCinematicInProgress__DelegateSignature(bInProgress) end
---@param bWasSkipped boolean
function UBlamCinematicSubsystem:OnCinematicEnd__DelegateSignature(bWasSkipped) end
---@param LevelSequence ULevelSequence
function UBlamCinematicSubsystem:OnCinematicBegin__DelegateSignature(LevelSequence) end
---@return boolean
function UBlamCinematicSubsystem:IsCinematicInProgress() end


---@class UBlamControllerHapticsSubsystem : UBlamGameInstanceSubsystem
local UBlamControllerHapticsSubsystem = {}

---@param Event UBlamHapticsEventBase
---@param Params FBlamControllerHapticsEventParams
---@return FBlamHapticsEventHandle
function UBlamControllerHapticsSubsystem:TriggerHapticsEvent(Event, Params) end
---@param HapticsEventHandle FBlamHapticsEventHandle
---@return boolean
function UBlamControllerHapticsSubsystem:StopHapticsEvent(HapticsEventHandle) end
---@param Event UBlamHapticsEventTriggerBase
---@param Params FBlamControllerHapticsEventParams
---@return FBlamHapticsEventHandle
function UBlamControllerHapticsSubsystem:SetWeaponTriggerResistance(Event, Params) end
---@param HapticsEventHandle FBlamHapticsEventHandle
---@return boolean
function UBlamControllerHapticsSubsystem:ResetWeaponTriggerResistance(HapticsEventHandle) end


---@class UBlamCookedTagReferencesEngineSubsystem : UEngineSubsystem
local UBlamCookedTagReferencesEngineSubsystem = {}


---@class UBlamDataSaveGame : UBlamSaveGame
local UBlamDataSaveGame = {}


---@class UBlamDebugMenuWidget : UUserWidget
---@field GameStateObjectDebugMenuWidget UBlamGameStateObjectDebugMenuWidget
local UBlamDebugMenuWidget = {}

---@param bShow boolean
---@param EnabledTypes TArray<boolean>
function UBlamDebugMenuWidget:SetShowTagDebugNames(bShow, EnabledTypes) end


---@class UBlamDebugMeshComponent : UDebugDrawComponent
local UBlamDebugMeshComponent = {}


---@class UBlamDecalManagerSaveGame : UBlamSaveGame
local UBlamDecalManagerSaveGame = {}


---@class UBlamDecalManagerSubsystem : UWorldSubsystem
---@field DecalOwner AActor
---@field TrackedDecals TMap<int32, UDecalComponent>
local UBlamDecalManagerSubsystem = {}

---@param DecalMaterial UMaterialInterface
---@param DecalTransform FTransform
---@param DecalSize FVector
---@param SpawnDelayTime float
---@return int32
function UBlamDecalManagerSubsystem:SpawnTrackedDecalDelayed(DecalMaterial, DecalTransform, DecalSize, SpawnDelayTime) end
---@param DecalMaterial UMaterialInterface
---@param DecalTransform FTransform
---@param DecalSize FVector
---@return int32
function UBlamDecalManagerSubsystem:SpawnTrackedDecal(DecalMaterial, DecalTransform, DecalSize) end
---@param DecalIndentifier int32
---@return boolean
function UBlamDecalManagerSubsystem:DestroyTrackedDecal(DecalIndentifier) end


---@class UBlamDeferredEventHandlerSubsystem : UEngineSubsystem
local UBlamDeferredEventHandlerSubsystem = {}


---@class UBlamDeveloperSettings : UDeveloperSettings
---@field CustomizationGlobalsTag TSoftObjectPtr<UBlamPlayerModelCustomizationGlobalsTagDataAsset>
---@field ProgressDataAsset TSoftObjectPtr<UBlamProgressDataAsset>
---@field AchievementListDataAsset TSoftObjectPtr<UBlamAchievementListDataAsset>
---@field InitialInstalledScenarioNames TArray<FName>
local UBlamDeveloperSettings = {}

---@param StartingScenarioName FName
---@return boolean
function UBlamDeveloperSettings:LevelIsReadyToAttemptLoading(StartingScenarioName) end


---@class UBlamEngineAssetManager : UHaloAssetManager
---@field BuiltInMapInfoDataPath TSoftObjectPtr<UBlamBuiltInMapInfoDataAsset>
local UBlamEngineAssetManager = {}



---@class UBlamEngineAudioGameSubsystem : UBlamGameInstanceSubsystem
---@field PostLoadingScreenDelayFrames int32
---@field PostPauseMenuDelayFrames int32
local UBlamEngineAudioGameSubsystem = {}

---@return UWorld
function UBlamEngineAudioGameSubsystem:TryGetWorld() end
---@return FSoftObjectPath
function UBlamEngineAudioGameSubsystem:TryGetPlayingCinematic() end
---@return ABlamGameState
function UBlamEngineAudioGameSubsystem:TryGetBlamGameState() end
---@param AkStateValue UAkStateValue
function UBlamEngineAudioGameSubsystem:SetGlobalState(AkStateValue) end
---@param AkRtpc UAkRtpc
---@param RtpcValue float
function UBlamEngineAudioGameSubsystem:SetGlobalRtpc(AkRtpc, RtpcValue) end
---@param MusicControl UHaloAudioMusicControl
function UBlamEngineAudioGameSubsystem:SendMusicEvent(MusicControl) end
---@param AkEvent UAkAudioEvent
function UBlamEngineAudioGameSubsystem:SendGlobalEvent(AkEvent) end
---@param OldState EBlamEngineAudioState
---@param NewState EBlamEngineAudioState
function UBlamEngineAudioGameSubsystem:OnStateChanged(OldState, NewState) end
---@param SkullsAdded FGameplayTagContainer
function UBlamEngineAudioGameSubsystem:OnSkullsRemoved(SkullsAdded) end
---@param SkullsAdded FGameplayTagContainer
function UBlamEngineAudioGameSubsystem:OnSkullsAdded(SkullsAdded) end
function UBlamEngineAudioGameSubsystem:OnReturnToMainMenuTriggered() end
function UBlamEngineAudioGameSubsystem:OnLoadLoadingManagerLoadFinishedOrFailed() end
function UBlamEngineAudioGameSubsystem:OnLoadingManagerLoadStarted() end
function UBlamEngineAudioGameSubsystem:OnInitialize() end
function UBlamEngineAudioGameSubsystem:OnDeinitialize() end
---@param bWasSkipped boolean
function UBlamEngineAudioGameSubsystem:OnCinematicSubsystemEndCinematic(bWasSkipped) end
---@param LevelSequence ULevelSequence
function UBlamEngineAudioGameSubsystem:OnCinematicSubsystemBeginCinematic(LevelSequence) end
---@param Cinematic FSoftObjectPath
---@param bWasSkipped boolean
function UBlamEngineAudioGameSubsystem:OnCinematicEnd(Cinematic, bWasSkipped) end
---@param Cinematic FSoftObjectPath
function UBlamEngineAudioGameSubsystem:OnCinematicBegin(Cinematic) end
---@return boolean
function UBlamEngineAudioGameSubsystem:IsNetworkCoop() end
---@return EBlamEngineAudioState
function UBlamEngineAudioGameSubsystem:GetState() end
---@return boolean
function UBlamEngineAudioGameSubsystem:GetIsPaused() end
---@return FGameplayTagContainer
function UBlamEngineAudioGameSubsystem:GetActiveSkulls() end


---@class UBlamEngineAudioSaveGame : UBlamSaveGame
local UBlamEngineAudioSaveGame = {}


---@class UBlamEngineGlueOuterSubsystemImpl : UBlamEngineGlueOuterSubsystem
local UBlamEngineGlueOuterSubsystemImpl = {}


---@class UBlamEngineHelperLibrary : UBlueprintFunctionLibrary
local UBlamEngineHelperLibrary = {}

---@return boolean
function UBlamEngineHelperLibrary:WithEditorOnlyData() end
---@param Actor AActor
---@return boolean
function UBlamEngineHelperLibrary:SetActorTransientFlag(Actor) end
---@param InHandle FBlamHapticsEventHandle
---@return boolean
function UBlamEngineHelperLibrary:IsDevicePropertyHandleValid(InHandle) end
---@param WorldContextObject UObject
---@param bFound boolean
---@return float
function UBlamEngineHelperLibrary:GetWorldNorth(WorldContextObject, bFound) end
---@return UBlamInputMapper
function UBlamEngineHelperLibrary:GetBlamInputMapper() end
---@param Parent UMaterialInterface
---@param Outer UObject
---@param OptionalName FName
---@return UMaterialInstanceDynamic
function UBlamEngineHelperLibrary:CreateMIDEditorOnly(Parent, Outer, OptionalName) end


---@class UBlamEngineLoadingManagerEngineSubsystem : UEngineSubsystem
---@field OnLoadStarted_BP FBlamEngineLoadingManagerEngineSubsystemOnLoadStarted_BP
---@field OnLoadCompleted_BP FBlamEngineLoadingManagerEngineSubsystemOnLoadCompleted_BP
---@field OnLoadFailed_BP FBlamEngineLoadingManagerEngineSubsystemOnLoadFailed_BP
---@field ScenarioToLoadGameOptions TOptional<FBlamScenarioGameOptions>
local UBlamEngineLoadingManagerEngineSubsystem = {}

function UBlamEngineLoadingManagerEngineSubsystem:OnLoadStartedEvent_BP__DelegateSignature() end
function UBlamEngineLoadingManagerEngineSubsystem:OnLoadFailedEvent_BP__DelegateSignature() end
function UBlamEngineLoadingManagerEngineSubsystem:OnLoadCompletedEvent_BP__DelegateSignature() end


---@class UBlamEnginePluginSettings : UDeveloperSettings
---@field BlamEngineFolder FDirectoryPath
---@field BuildConfiguration EBlamEngineBuildConfiguration
---@field BuildConfigurationToolsDll EBlamEngineBuildConfiguration
---@field bDisableBlamEngine boolean
---@field bDesireClangHaloSimulationDll boolean
---@field bUseTagIoIHandler boolean
---@field bEditorEnableTagSystemShellSmokeTestsOnStartup boolean
---@field bEditorSynchronization boolean
---@field bShowSynchronizedObjectsInOutliner boolean
---@field NumSaveSlots uint8
local UBlamEnginePluginSettings = {}



---@class UBlamEngineSynchronizationManager : UWorldSubsystem
local UBlamEngineSynchronizationManager = {}


---@class UBlamFrontendLevelsEngineGlueSubsystem : UBlamEngineGlueSubsystem
---@field BuiltInMapInfoData UBlamBuiltInMapInfoDataAsset
local UBlamFrontendLevelsEngineGlueSubsystem = {}



---@class UBlamGameAllegianceSubsystem : UBlamGameInstanceSubsystem
local UBlamGameAllegianceSubsystem = {}


---@class UBlamGameEngineBaseVariant : UObject
local UBlamGameEngineBaseVariant = {}

---@param SocialOptions FBlamGameEngineSocialOptions
function UBlamGameEngineBaseVariant:SetSocialOptions(SocialOptions) end
---@return FBlamGameEngineSocialOptions
function UBlamGameEngineBaseVariant:GetSocialOptions() end


---@class UBlamGameEngineCampaignVariant : UBlamGameEngineBaseVariant
---@field CampaignVariantStorage FBlamGameEngineCampaignVariantStorage
local UBlamGameEngineCampaignVariant = {}

---@param CampaignPlayerIndex int32
---@param PlayerTraits FBlamGameEnginePlayerTraits
function UBlamGameEngineCampaignVariant:SetPerPlayerTraits(CampaignPlayerIndex, PlayerTraits) end
---@param Flags FBlamCampaignVariantFlags
function UBlamGameEngineCampaignVariant:SetFlags(Flags) end
---@param CampaignPlayerIndex int32
---@return FBlamGameEnginePlayerTraits
function UBlamGameEngineCampaignVariant:GetPerPlayerTraits(CampaignPlayerIndex) end
---@return FBlamCampaignVariantFlags
function UBlamGameEngineCampaignVariant:GetFlags() end


---@class UBlamGameInstance : UHaloOnlineGameInstance
local UBlamGameInstance = {}


---@class UBlamGameInstanceSubsystem : UGameInstanceSubsystem
local UBlamGameInstanceSubsystem = {}


---@class UBlamGameStateObjectDebugMenuWidget : UUserWidget
---@field BipedColor FLinearColor
---@field ControlColor FLinearColor
---@field CrateColor FLinearColor
---@field CreatureColor FLinearColor
---@field EffectSceneryColor FLinearColor
---@field EquipmentColor FLinearColor
---@field GiantColor FLinearColor
---@field MachineColor FLinearColor
---@field ProjectileColor FLinearColor
---@field SceneryColor FLinearColor
---@field SoundSceneryColor FLinearColor
---@field TerminalColor FLinearColor
---@field VehicleColor FLinearColor
---@field WeaponColor FLinearColor
local UBlamGameStateObjectDebugMenuWidget = {}



---@class UBlamGameUserSettings : UHaloUserSettings
---@field OnBlamSettingsUpdated FBlamGameUserSettingsOnBlamSettingsUpdated
---@field InProgress FString
---@field SubtitlesEnabled int32
---@field SubtitleFriendlySpeakerColor FString
---@field SubtitleEnemySpeakerColor FString
---@field SubtitleNeutralSpeakerColor FString
---@field SubtitleDialogueColor FString
---@field SubtitleFontWeight FString
---@field SubtitleLetterSpacing float
---@field SubtitleLineSpacing float
---@field SubtitleTextCaps FString
---@field SubtitleBackingColor FString
---@field SubtitleBackingOpacity float
---@field ColorCorrectionFilter EColorVisionDeficiency
---@field ColorCorrectionStrength float
---@field ColorCorrectionBrightness float
---@field ColorCorrectionContrast float
---@field bTutorialTips boolean
---@field bObjectiveHints boolean
---@field ShowingHUDObjectives FString
---@field ShowingHUDBanners FString
---@field ShowingMenuToasts FString
---@field bAnimatedMenuBackground boolean
---@field bFlashingEffects boolean
---@field bScreenShake boolean
---@field bMotionBlur boolean
---@field FrontendBackerOpacity float
---@field IngameBackerOpacity float
---@field CrosshairSize float
---@field CrosshairColor FString
---@field CrosshairOverEnemyColor FString
---@field CrosshairOverFriendlyColor FString
---@field CrosshairOutlineOpacity float
---@field CrosshairOutlineThickness float
---@field bHitMarkersEnabled boolean
---@field HUDWidgetScaling float
---@field HUDBackingOpacity float
---@field MotionTrackerEnemyColor FString
---@field MotionTrackerFriendlyColor FString
---@field bHUDParallax boolean
---@field HUDGlitch float
---@field DamageScreenEffectsOpacity float
---@field bChromaticAberration boolean
---@field DirectionalDamageIndicatorsOpacity float
---@field DirectionalDamageIndicatorsColor FString
---@field NavigationPointSize float
---@field NavigationPointOpacity float
---@field NavigationPointColour FString
---@field TeammateMarkerSize float
---@field TeammateMarkerOpacity float
---@field TeammateMarkerColour FString
---@field SelectedControllerInputMappingPreset FString
---@field SelectedKBMInputMappingPreset FString
---@field bAllowInCoop boolean
---@field ModifierPreset EModifierPresetSetting
---@field PlayerTraits1 FBlamGameEnginePlayerTraits
---@field PlayerTraits2 FBlamGameEnginePlayerTraits
---@field PlayerTraits3 FBlamGameEnginePlayerTraits
---@field PlayerTraits4 FBlamGameEnginePlayerTraits
---@field bFriendlyFire boolean
---@field FieldOfView int32
---@field FieldOfView3rdPerson int32
---@field bHUDVisible boolean
---@field HUDOpacity float
---@field HUDAnchoring FString
---@field HUDLayout EHudLayoutSetting
---@field bFPSCounter boolean
---@field DistanceUnits EHudNavpointDistanceUnitsSetting
---@field bGoreBloodEnabled boolean
---@field MeleeWeaponOffsetHorizontal int32
---@field MeleeWeaponOffsetVertical int32
---@field MeleeWeaponOffsetDepth int32
---@field PistolOffsetHorizontal int32
---@field PistolOffsetVertical int32
---@field PistolOffsetDepth int32
---@field RifleOffsetHorizontal int32
---@field RifleOffsetVertical int32
---@field RifleOffsetDepth int32
---@field HeavyWeaponOffsetHorizontal int32
---@field HeavyWeaponOffsetVertical int32
---@field HeavyWeaponOffsetDepth int32
---@field HDR int32
---@field Contrast float
---@field Brightness float
---@field bVSync boolean
---@field bAsyncCompute boolean
---@field FrameRate EVideoFramerateSetting
---@field bFrameGeneration boolean
---@field LowLatencyMode EVideoLowLatencyMode
---@field MinimumFrameRate int32
---@field MaximumFrameRate int32
---@field Monitor FString
---@field AspectRatio EVideoAspectRatioSetting
---@field bBorderlessFullscreen boolean
---@field ResolutionScale float
---@field Upscaler EVideoUpscalerSetting
---@field QualityPreset EVideoQualitySetting
---@field SwapChainProvider EVideoSwapChainProvider
---@field UpscalingQuality EVideoUpscalingQualitySetting
---@field TextureQuality EVideoQualitySetting
---@field GeometryQuality EVideoQualitySetting
---@field ReflectionsQuality EVideoQualitySetting
---@field GlobalIlluminationQuality EVideoQualitySetting
---@field LightingQuality EVideoQualitySetting
---@field EffectsQuality EVideoQualitySetting
---@field AtmosphericsQuality EVideoQualitySetting
---@field PostprocessingQuality EVideoQualitySetting
---@field VisualLanguage FString
---@field MouseLookSensitivity float
---@field MouseLookSensitivityHorizontal float
---@field MouseLookSensitivityVertical float
---@field bMouseSmoothingEnabled boolean
---@field bMouseAccelerationEnabled boolean
---@field MouseAccelerationScale float
---@field MouseAccelerationMinRate float
---@field MouseAccelerationMaxRate float
---@field MouseAccelerationExp float
---@field bMouseKeyboardInvertX boolean
---@field bMouseKeyboardInvertY boolean
---@field bMouseKeyboardFlightInvertX boolean
---@field bMouseKeyboardFlightInvertY boolean
---@field MouseKeyboardWarthogDrivingMode EBlamDrivingMode
---@field bMouseKeyboardHoldToCrouch boolean
---@field ControllerWarthogDrivingMode EBlamDrivingMode
---@field bControllerHoldToCrouch boolean
---@field bControllerAutoLookCentering boolean
---@field bControllerAimMagnetism boolean
---@field ControllerLookSensitivityHorizontal EBlamLookSensitivity
---@field ControllerLookSensitivityVertical EBlamLookSensitivity
---@field ControllerThumbstickLayout EBlamJoystickPresets
---@field ControllerLookAxialDeadZone float
---@field ControllerLookRadialDeadZone float
---@field ControllerLookAcceleration EBlamLookAcceleration
---@field bControllerInvertX boolean
---@field bControllerInvertY boolean
---@field bControllerFlightInvertX boolean
---@field bControllerFlightInvertY boolean
---@field ControllerVibration float
---@field bControllerTriggerEffectsEnabled boolean
---@field bControllerLightEffectsEnabled boolean
---@field bControllerSpeaker boolean
---@field VolumeControllerSpeaker float
---@field CustomInputMappingGamepad FBlamCustomMappingContext
---@field CustomInputMappingKBM FBlamCustomMappingContext
---@field ObjectCustomizationNames TArray<FGameplayTag>
local UBlamGameUserSettings = {}

---@param bNewValue boolean
function UBlamGameUserSettings:SetVSync(bNewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetVolumeControllerSpeaker(NewValue) end
---@param NewValue EVideoUpscalingQualitySetting
function UBlamGameUserSettings:SetUpscalingQualitySetting(NewValue) end
---@param NewValue EVideoUpscalerSetting
function UBlamGameUserSettings:SetUpscaler(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetTextureQualitySetting(NewValue) end
---@param NewKBMInputMappingPreset FString
function UBlamGameUserSettings:SetSelectedKBMInputMappingPreset(NewKBMInputMappingPreset) end
---@param NewControllerInputMappingPreset FString
function UBlamGameUserSettings:SetSelectedControllerInputMappingPreset(NewControllerInputMappingPreset) end
---@param NewValue boolean
function UBlamGameUserSettings:SetScreenShake(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetRifleOffsetVertical(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetRifleOffsetHorizontal(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetRifleOffsetDepth(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetResolutionScale(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetReflectionsQualitySetting(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetQualityPreset(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetPostprocessingQualitySetting(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetPistolOffsetVertical(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetPistolOffsetHorizontal(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetPistolOffsetDepth(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseSmoothingEnabled(bNewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseLookSensitivityVertical(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseLookSensitivityHorizontal(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseLookSensitivity(NewValue) end
---@param NewValue EBlamDrivingMode
function UBlamGameUserSettings:SetMouseKeyboardWarthogDrivingMode(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseKeyboardInvertY(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseKeyboardInvertX(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseKeyboardHoldToCrouch(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseKeyboardFlightInvertY(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseKeyboardFlightInvertX(bNewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseAccelerationScale(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseAccelerationMinRate(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseAccelerationMaxRate(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetMouseAccelerationExp(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetMouseAccelerationEnabled(bNewValue) end
---@param NewValue boolean
function UBlamGameUserSettings:SetMotionBlur(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetMeleeWeaponOffsetVertical(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetMeleeWeaponOffsetHorizontal(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetMeleeWeaponOffsetDepth(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetMaximumFrameRate(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetLightingQualitySetting(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetHeavyWeaponOffsetVertical(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetHeavyWeaponOffsetHorizontal(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetHeavyWeaponOffsetDepth(NewValue) end
---@param NewValue int32
function UBlamGameUserSettings:SetHDR(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetGlobalIlluminationQualitySetting(NewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetGeometryQualitySetting(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetFrameGeneration(bNewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetEffectsQualitySetting(NewValue) end
---@param NewValue EBlamDrivingMode
function UBlamGameUserSettings:SetControllerWarthogDrivingMode(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetControllerVibration(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerTriggerEffectsEnabled(bNewValue) end
---@param NewValue EBlamJoystickPresets
function UBlamGameUserSettings:SetControllerThumbstickLayout(NewValue) end
---@param NewValue boolean
function UBlamGameUserSettings:SetControllerSpeaker(NewValue) end
---@param NewValue EBlamLookSensitivity
function UBlamGameUserSettings:SetControllerLookSensitivityVertical(NewValue) end
---@param NewValue EBlamLookSensitivity
function UBlamGameUserSettings:SetControllerLookSensitivityHorizontal(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetControllerLookRadialDeadZone(NewValue) end
---@param NewValue float
function UBlamGameUserSettings:SetControllerLookAxialDeadZone(NewValue) end
---@param NewValue EBlamLookAcceleration
function UBlamGameUserSettings:SetControllerLookAcceleration(NewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerLightEffectsEnabled(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerInvertY(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerInvertX(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerHoldToCrouch(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerFlightInvertY(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerFlightInvertX(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerAutoLookCentering(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetControllerAimMagnetism(bNewValue) end
---@param bNewValue boolean
function UBlamGameUserSettings:SetBorderlessFullscreenEnabled(bNewValue) end
---@param NewValue EVideoQualitySetting
function UBlamGameUserSettings:SetAtmosphericsQualitySetting(NewValue) end
---@return boolean
function UBlamGameUserSettings:GetVSyncEnabled() end
---@return float
function UBlamGameUserSettings:GetVolumeControllerSpeaker() end
---@return EVideoUpscalingQualitySetting
function UBlamGameUserSettings:GetUpscalingQualitySetting() end
---@return EVideoUpscalerSetting
function UBlamGameUserSettings:GetUpscaler() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetTextureQualitySetting() end
---@return FString
function UBlamGameUserSettings:GetSelectedKBMInputMappingPreset() end
---@return FString
function UBlamGameUserSettings:GetSelectedControllerInputMappingPreset() end
---@return boolean
function UBlamGameUserSettings:GetScreenShake() end
---@return int32
function UBlamGameUserSettings:GetRifleOffsetVertical() end
---@return int32
function UBlamGameUserSettings:GetRifleOffsetHorizontal() end
---@return int32
function UBlamGameUserSettings:GetRifleOffsetDepth() end
---@return float
function UBlamGameUserSettings:GetResolutionScale() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetReflectionsQualitySetting() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetQualityPreset() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetPostprocessingQualitySetting() end
---@return int32
function UBlamGameUserSettings:GetPistolOffsetVertical() end
---@return int32
function UBlamGameUserSettings:GetPistolOffsetHorizontal() end
---@return int32
function UBlamGameUserSettings:GetPistolOffsetDepth() end
---@return boolean
function UBlamGameUserSettings:GetMouseSmoothingEnabled() end
---@return float
function UBlamGameUserSettings:GetMouseLookSensitivityVertical() end
---@return float
function UBlamGameUserSettings:GetMouseLookSensitivityHorizontal() end
---@return float
function UBlamGameUserSettings:GetMouseLookSensitivity() end
---@return EBlamDrivingMode
function UBlamGameUserSettings:GetMouseKeyboardWarthogDrivingMode() end
---@return boolean
function UBlamGameUserSettings:GetMouseKeyboardInvertY() end
---@return boolean
function UBlamGameUserSettings:GetMouseKeyboardInvertX() end
---@return boolean
function UBlamGameUserSettings:GetMouseKeyboardHoldToCrouch() end
---@return boolean
function UBlamGameUserSettings:GetMouseKeyboardFlightInvertY() end
---@return boolean
function UBlamGameUserSettings:GetMouseKeyboardFlightInvertX() end
---@return float
function UBlamGameUserSettings:GetMouseAccelerationScale() end
---@return float
function UBlamGameUserSettings:GetMouseAccelerationMinRate() end
---@return float
function UBlamGameUserSettings:GetMouseAccelerationMaxRate() end
---@return float
function UBlamGameUserSettings:GetMouseAccelerationExp() end
---@return boolean
function UBlamGameUserSettings:GetMouseAccelerationEnabled() end
---@return boolean
function UBlamGameUserSettings:GetMotionBur() end
---@return int32
function UBlamGameUserSettings:GetMeleeWeaponOffsetVertical() end
---@return int32
function UBlamGameUserSettings:GetMeleeWeaponOffsetHorizontal() end
---@return int32
function UBlamGameUserSettings:GetMeleeWeaponOffsetDepth() end
---@return int32
function UBlamGameUserSettings:GetMaximumFrameRate() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetLightingQualitySetting() end
---@return boolean
function UBlamGameUserSettings:GetHudVisible() end
---@return int32
function UBlamGameUserSettings:GetHeavyWeaponOffsetVertical() end
---@return int32
function UBlamGameUserSettings:GetHeavyWeaponOffsetHorizontal() end
---@return int32
function UBlamGameUserSettings:GetHeavyWeaponOffsetDepth() end
---@return int32
function UBlamGameUserSettings:GetHDR() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetGlobalIlluminationQualitySetting() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetGeometryQualitySetting() end
---@return EVideoFramerateSetting
function UBlamGameUserSettings:GetFrameRate() end
---@return boolean
function UBlamGameUserSettings:GetFrameGeneration() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetEffectsQualitySetting() end
---@return EBlamDrivingMode
function UBlamGameUserSettings:GetControllerWarthogDrivingMode() end
---@return float
function UBlamGameUserSettings:GetControllerVibration() end
---@return boolean
function UBlamGameUserSettings:GetControllerTriggerEffectsEnabled() end
---@return EBlamJoystickPresets
function UBlamGameUserSettings:GetControllerThumbstickLayout() end
---@return boolean
function UBlamGameUserSettings:GetControllerSpeaker() end
---@return EBlamLookSensitivity
function UBlamGameUserSettings:GetControllerLookSensitivityVertical() end
---@return EBlamLookSensitivity
function UBlamGameUserSettings:GetControllerLookSensitivityHorizontal() end
---@return float
function UBlamGameUserSettings:GetControllerLookRadialDeadZone() end
---@return float
function UBlamGameUserSettings:GetControllerLookAxialDeadZone() end
---@return EBlamLookAcceleration
function UBlamGameUserSettings:GetControllerLookAcceleration() end
---@return boolean
function UBlamGameUserSettings:GetControllerLightEffectsEnabled() end
---@return boolean
function UBlamGameUserSettings:GetControllerInvertY() end
---@return boolean
function UBlamGameUserSettings:GetControllerInvertX() end
---@return boolean
function UBlamGameUserSettings:GetControllerHoldToCrouch() end
---@return boolean
function UBlamGameUserSettings:GetControllerFlightInvertY() end
---@return boolean
function UBlamGameUserSettings:GetControllerFlightInvertX() end
---@return boolean
function UBlamGameUserSettings:GetControllerAutoLookCentering() end
---@return boolean
function UBlamGameUserSettings:GetControllerAimMagnetism() end
---@return boolean
function UBlamGameUserSettings:GetBorderlessFullscreenEnabled() end
---@return EVideoQualitySetting
function UBlamGameUserSettings:GetAtmosphericsQualitySetting() end
---@param CustomizationToMatch FGameplayTag
---@return FGameplayTag
function UBlamGameUserSettings:FindCustomizationMatching(CustomizationToMatch) end
function UBlamGameUserSettings:ApplyVisualLanguage() end
---@param CustomizationToReplace FGameplayTag
---@param NewSelection FGameplayTag
function UBlamGameUserSettings:AddOrReplaceCustomization(CustomizationToReplace, NewSelection) end


---@class UBlamGamepadEventHandlerSubsystem : UBlamGameInstanceSubsystem
---@field LoadedLightEventsDataAsset UBlamGamepadLightEventDataAsset
local UBlamGamepadEventHandlerSubsystem = {}

---@param Incident FBlamIncident
function UBlamGamepadEventHandlerSubsystem:OnBlamIncident(Incident) end
---@param LocalPlayerIndex int32
---@param EventName FName
function UBlamGamepadEventHandlerSubsystem:AddGamepadLightEvent(LocalPlayerIndex, EventName) end


---@class UBlamGamepadLightEventDataAsset : UDataAsset
---@field LightEvents TArray<FGamepadLightEventData>
local UBlamGamepadLightEventDataAsset = {}



---@class UBlamHapticsLocalPlayerSubsystem : ULocalPlayerSubsystem
local UBlamHapticsLocalPlayerSubsystem = {}

---@param UserId FPlatformUserId
---@param DeviceID FInputDeviceId
function UBlamHapticsLocalPlayerSubsystem:OnHardwareInputDeviceChanged(UserId, DeviceID) end


---@class UBlamIncidentHandlerLocalPlayerSubsystem : ULocalPlayerSubsystem
local UBlamIncidentHandlerLocalPlayerSubsystem = {}


---@class UBlamIncidentSubsystem : UBlamGameInstanceSubsystem
---@field OnIncident FBlamIncidentSubsystemOnIncident
local UBlamIncidentSubsystem = {}

---@param Incident FBlamIncident
function UBlamIncidentSubsystem:OnIncident__DelegateSignature(Incident) end


---@class UBlamInputAction : UInputAction
---@field bAllowUnmappedAction boolean
---@field ActionExclusivityContextFlags uint32
---@field FriendInputActions TSet<UBlamInputAction>
---@field InvalidKeyMappings TSet<UInputMappingContext>
local UBlamInputAction = {}



---@class UBlamInputActionsMapDataAsset : UDataAsset
---@field BlamInputActionsMap TMap<EBlamInputAction, UBlamInputAction>
local UBlamInputActionsMapDataAsset = {}



---@class UBlamInputDeviceAudioVibrationProperty : UInputDeviceProperty
local UBlamInputDeviceAudioVibrationProperty = {}


---@class UBlamInputDeviceForceFeedbackVibrationProperty : UInputDeviceProperty
local UBlamInputDeviceForceFeedbackVibrationProperty = {}


---@class UBlamInputDeviceTriggerEffectProperty : UInputDeviceTriggerEffect
local UBlamInputDeviceTriggerEffectProperty = {}


---@class UBlamInputDeviceTriggerResetProperty : UInputDeviceTriggerEffect
local UBlamInputDeviceTriggerResetProperty = {}


---@class UBlamInputDeviceTriggerVibrationProperty : UInputDeviceTriggerEffect
local UBlamInputDeviceTriggerVibrationProperty = {}


---@class UBlamInputMapper : UObject
---@field CreatedCustomPreset FBlamInputMapperCreatedCustomPreset
---@field UpdatedCustomPreset FBlamInputMapperUpdatedCustomPreset
---@field OnAppliedPreset FBlamInputMapperOnAppliedPreset
---@field FixedInputPresets TMap<FName, FBlamInputPreset>
---@field GamepadInputActions TSet<UBlamInputAction>
---@field MouseAndKeyboardInputActions TSet<UBlamInputAction>
---@field CustomInputPresetsGamepad TArray<FBlamInputPreset>
---@field CustomInputPresetsKBM TArray<FBlamInputPreset>
local UBlamInputMapper = {}

---@param LocalPlayerIndex int32
---@param BlamInputAction EBlamInputAction
---@param InputDevice EBlamInputDeviceType
---@param KeySlot EBlamKeyBindingSlot
function UBlamInputMapper:UnmapKeyForBlamInputAction(LocalPlayerIndex, BlamInputAction, InputDevice, KeySlot) end
---@param LocalPlayerIndex int32
---@param Key FKey
---@param Action UBlamInputAction
---@param InputDevice EBlamInputDeviceType
---@param KeySlot EBlamKeyBindingSlot
function UBlamInputMapper:UnmapAllConflictingBlamInputActionsFromKey(LocalPlayerIndex, Key, Action, InputDevice, KeySlot) end
---@param LocalPlayerIndex int32
---@param Action UBlamInputAction
---@param NewKey FKey
---@param OutInputMapperOutputErrorData FInputMapperOutputErrorData
---@param KeySlot EBlamKeyBindingSlot
---@param bSkipExclusivity boolean
---@return EInputMapperErrorCode
function UBlamInputMapper:TryAndSetKeyForAction(LocalPlayerIndex, Action, NewKey, OutInputMapperOutputErrorData, KeySlot, bSkipExclusivity) end
---@param PresetName FName
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:SetSelectedPreset(PresetName, LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@param Action UBlamInputAction
---@param NewKey FKey
---@param OutInputMapperOutputErrorData FInputMapperOutputErrorData
---@param KeySlot EBlamKeyBindingSlot
---@param bSkipExclusivity boolean
---@return EInputMapperErrorCode
function UBlamInputMapper:SetKeyForAction(LocalPlayerIndex, InputDevice, Action, NewKey, OutInputMapperOutputErrorData, KeySlot, bSkipExclusivity) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:SaveSelectedPreset(LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:SaveCustomPreset(LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:ResetCustomPreset(LocalPlayerIndex, InputDevice) end
---@param LocalUserIndex int32
---@param InputDevice EBlamInputDeviceType
function UBlamInputMapper:OnUpdatedCustomPreset__DelegateSignature(LocalUserIndex, InputDevice) end
---@param LocalUserIndex int32
---@param InputDevice EBlamInputDeviceType
function UBlamInputMapper:OnCreatedCustomPreset__DelegateSignature(LocalUserIndex, InputDevice) end
---@param LocalUserIndex int32
---@param InputDevice EBlamInputDeviceType
function UBlamInputMapper:OnAppliedPreset__DelegateSignature(LocalUserIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:IsCustomPresetValid(LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param Action UBlamInputAction
---@param InputDevice EBlamInputDeviceType
---@param KeySlot EBlamKeyBindingSlot
---@return boolean
function UBlamInputMapper:IsActionMappingValid(LocalPlayerIndex, Action, InputDevice, KeySlot) end
---@param LocalPlayerIndex int32
---@param Action UBlamInputAction
---@param InputDevice EBlamInputDeviceType
---@param KeySlot EBlamKeyBindingSlot
---@return FKey
function UBlamInputMapper:GetKeyForAction(LocalPlayerIndex, Action, InputDevice, KeySlot) end
---@param PresetName FName
---@param LocalPlayerIndex int32
---@return FBlamInputPreset
function UBlamInputMapper:GetFixedPreset(PresetName, LocalPlayerIndex) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return FBlamInputPreset
function UBlamInputMapper:GetCustomPreset(LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return FName
function UBlamInputMapper:GetBasePresetForCustomPreset(LocalPlayerIndex, InputDevice) end
---@param LocalPlayerIndex int32
---@param InputDevice EBlamInputDeviceType
---@return boolean
function UBlamInputMapper:CustomPresetDoesNotExistOrIsValid(LocalPlayerIndex, InputDevice) end


---@class UBlamInputProcessorLocalPlayerSubsystem : ULocalPlayerSubsystem
local UBlamInputProcessorLocalPlayerSubsystem = {}

---@param bUIActive boolean
function UBlamInputProcessorLocalPlayerSubsystem:SetUIActive(bUIActive) end


---@class UBlamLocalPlayer : UHaloOnlineLocalPlayer
local UBlamLocalPlayer = {}

---@param Incident FBlamIncident
function UBlamLocalPlayer:OnIncident(Incident) end


---@class UBlamLocalUnitInventoryComponent : UActorComponent
local UBlamLocalUnitInventoryComponent = {}


---@class UBlamMetaDataSaveGame : UBlamSaveGame
---@field CurrentScenarioIndex int32
---@field SavedScenarioGameOptions FBlamScenarioGameOptions
---@field CurrentCampaignDataAssetPtr TSoftObjectPtr<UBlamCampaignDataAsset>
---@field TimestampUTC FDateTime
local UBlamMetaDataSaveGame = {}



---@class UBlamObjectCustomizationSubsystem : UEngineSubsystem
local UBlamObjectCustomizationSubsystem = {}


---@class UBlamPlayerEffectSubsystem : UBlamGameInstanceSubsystem
---@field OnPlayerEffect FBlamPlayerEffectSubsystemOnPlayerEffect
local UBlamPlayerEffectSubsystem = {}

---@param PlayerEffect FBlamPlayerEffect
function UBlamPlayerEffectSubsystem:OnPlayerEffect__DelegateSignature(PlayerEffect) end


---@class UBlamPlayerMappableKeySettings : UPlayerMappableKeySettings
---@field InputDevice EBlamInputDeviceType
---@field BindingSlot EBlamKeyBindingSlot
---@field bIgnore boolean
local UBlamPlayerMappableKeySettings = {}



---@class UBlamProgressDataAsset : UDataAsset
---@field ProgressSaveSlotName FString
---@field ProgressSaveGameClass TSubclassOf<UBlamProgressLocalPlayerSaveGame>
---@field IncidentToGameplayTags FBlamIncidentNameToProgressMap
---@field MissionCompletionProgress FBlamIncidentNameToMissionCompletionProgress
local UBlamProgressDataAsset = {}



---@class UBlamProgressLocalPlayerSaveGame : ULocalPlayerSaveGame
---@field GameProgression FBlamGameProgression
---@field GameProfile FBlamGameProfile
---@field GameplayTags FGameplayTagContainer
---@field NotifiedGameplayTags FGameplayTagContainer
---@field OwnedPlayFabEntitlements TArray<FString>
local UBlamProgressLocalPlayerSaveGame = {}



---@class UBlamProgressLocalPlayerSubsystem : UBlamIncidentHandlerLocalPlayerSubsystem
---@field OnProgressionIncident FBlamProgressLocalPlayerSubsystemOnProgressionIncident
local UBlamProgressLocalPlayerSubsystem = {}

function UBlamProgressLocalPlayerSubsystem:UpdateNotifiedGameplayTags() end
---@return UBlamProgressLocalPlayerSaveGame
function UBlamProgressLocalPlayerSubsystem:TryAndGetSaveGame() end
---@param ProgressGameplayTag FGameplayTag
function UBlamProgressLocalPlayerSubsystem:InjectProgressGameplayTag(ProgressGameplayTag) end


---@class UBlamRenderSettingsManagerGameInstanceSubsystem : UGameInstanceSubsystem
local UBlamRenderSettingsManagerGameInstanceSubsystem = {}

---@param UpdateData FBlamRenderSettingsChangeData
function UBlamRenderSettingsManagerGameInstanceSubsystem:OnRenderSettingsChanged__DelegateSignature(UpdateData) end


---@class UBlamSaveGame : USaveGame
---@field SavedGameVersion int32
local UBlamSaveGame = {}



---@class UBlamSaveGameBlueprintLibrary : UBlueprintFunctionLibrary
local UBlamSaveGameBlueprintLibrary = {}

---@param Actor AActor
---@return boolean
function UBlamSaveGameBlueprintLibrary:RemoveSaveGameTrackedActor(Actor) end
---@param Actor AActor
---@return boolean
function UBlamSaveGameBlueprintLibrary:AddSaveGameTrackedActor(Actor) end
---@param Actor AActor
---@return boolean
function UBlamSaveGameBlueprintLibrary:AddActorToBeDestroyedOnBlamReset(Actor) end


---@class UBlamSaveGameWorldSubsystem : UWorldSubsystem
local UBlamSaveGameWorldSubsystem = {}


---@class UBlamSaveSlotSaveGame : UBlamSaveGame
---@field MetaData UBlamMetaDataSaveGame
---@field BlamSaveGame UBlamDataSaveGame
---@field UnrealWorldSaveGame UBlamUnrealWorldSaveGame
local UBlamSaveSlotSaveGame = {}



---@class UBlamSavedGameGameInstanceSubsystem : UBlamGameInstanceSubsystem
local UBlamSavedGameGameInstanceSubsystem = {}


---@class UBlamScenarioLifecycleEventsSubsystem : UEngineSubsystem
local UBlamScenarioLifecycleEventsSubsystem = {}


---@class UBlamScenarioObjectBindingComponent : UActorComponent
---@field OnObjectBoundEvent FBlamScenarioObjectBindingComponentOnObjectBoundEvent
---@field OnObjectUnboundEvent FBlamScenarioObjectBindingComponentOnObjectUnboundEvent
---@field ScenarioObjectIdentifier int32
local UBlamScenarioObjectBindingComponent = {}

---@return AActor
function UBlamScenarioObjectBindingComponent:TryAndGetBoundObjectActor() end
---@param OldBoundObjectActor AActor
function UBlamScenarioObjectBindingComponent:OnObjectUnbound__DelegateSignature(OldBoundObjectActor) end
---@param OldBoundObjectActor AActor
function UBlamScenarioObjectBindingComponent:OnObjectUnbound(OldBoundObjectActor) end
---@param NewBoundObjectActor AActor
---@param OldBoundObjectActor AActor
function UBlamScenarioObjectBindingComponent:OnObjectBound__DelegateSignature(NewBoundObjectActor, OldBoundObjectActor) end
---@param NewBoundObjectActor AActor
---@param OldBoundObjectActor AActor
function UBlamScenarioObjectBindingComponent:OnObjectBound(NewBoundObjectActor, OldBoundObjectActor) end


---@class UBlamSynchronizationHelperLibrary : UBlueprintFunctionLibrary
local UBlamSynchronizationHelperLibrary = {}

---@param WorldContextObject UObject
---@param MaterialResponseData FHaloMaterialResponseData
function UBlamSynchronizationHelperLibrary:SubmitMaterialResponseDataToResponseSubsystem(WorldContextObject, MaterialResponseData) end
---@param WorldContextObject UObject
---@param RequestedBlamInputUserIndex int32
---@param OutPlayerState APlayerState
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:ResolvePlayerStateUsingBlamInputUserIndex(WorldContextObject, RequestedBlamInputUserIndex, OutPlayerState) end
---@param WorldContextObject UObject
---@param RequestedBlamAbsolutePlayerIndex int32
---@param OutPlayerState APlayerState
---@return EResolveBlamAbsolutePlayerIndexResult
function UBlamSynchronizationHelperLibrary:ResolvePlayerStateUsingBlamAbsolutePlayerIndex(WorldContextObject, RequestedBlamAbsolutePlayerIndex, OutPlayerState) end
---@param WorldContextObject UObject
---@param RequestedPlayerDatumIndex int32
---@return EResolveBlamAbsolutePlayerIndexResult
function UBlamSynchronizationHelperLibrary:ResolveInGameBlamPlayerLocality(WorldContextObject, RequestedPlayerDatumIndex) end
---@param WorldContextObject UObject
---@param bInFadingIn boolean
---@param InFadeTimeInSeconds float
---@param InFadeColor FLinearColor
---@param bInFadeAudio boolean
---@param bInHoldWhenFinished boolean
---@return boolean
function UBlamSynchronizationHelperLibrary:LocalPlayersStartCameraFade(WorldContextObject, bInFadingIn, InFadeTimeInSeconds, InFadeColor, bInFadeAudio, bInHoldWhenFinished) end
---@param EffectData FBlamEffectData
---@param OutBarrel EBlamWeaponBarrel
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:GetWeaponBarrelFromEffectData(EffectData, OutBarrel) end
---@param WorldContextObject UObject
---@param EffectData FBlamEffectData
---@param TraceChannel ETraceTypeQuery
---@param ResolveOutcome EBlamHelperLibraryMaterialResolveOutcome
---@param ActorsToIgnore TArray<AActor>
---@param RayCastLength float
---@return FHaloMaterialResponseData
function UBlamSynchronizationHelperLibrary:GetMaterialResponseForEffect(WorldContextObject, EffectData, TraceChannel, ResolveOutcome, ActorsToIgnore, RayCastLength) end
---@param Skeleton USkeleton
---@param MarkerGroupName FName
---@param OutSocketNames TArray<FName>
---@return boolean
function UBlamSynchronizationHelperLibrary:GetEffectSocketNamesFromMarkerGroup(Skeleton, MarkerGroupName, OutSocketNames) end
---@param EffectData FBlamEffectData
---@param Skeleton USkeleton
---@param MarkerGroupName FName
---@return FName
function UBlamSynchronizationHelperLibrary:GetEffectSocketNameFromMarker(EffectData, Skeleton, MarkerGroupName) end
---@param WorldContextObject UObject
---@param EffectData FBlamEffectData
---@param TraceChannel ETraceTypeQuery
---@param ResolveOutcome EBlamHelperLibraryMaterialResolveOutcome
---@param ActorsToIgnore TArray<AActor>
---@param RayCastLength float
---@return FHaloMaterialResponseData
function UBlamSynchronizationHelperLibrary:GetAndSubmitMaterialResponseForEffect(WorldContextObject, EffectData, TraceChannel, ResolveOutcome, ActorsToIgnore, RayCastLength) end
---@param WorldContextObject UObject
---@param PhysicalMaterial UPhysicalMaterial
---@param OutMaterialGameplayTag FGameplayTag
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindSurfaceGameplayTagForPhysicalMaterial(WorldContextObject, PhysicalMaterial, OutMaterialGameplayTag) end
---@param WorldContextObject UObject
---@param EffectData FBlamEffectData
---@param HitResult FHitResult
---@param ActorsToIgnore TArray<AActor>
---@param CollisionChannel ECollisionChannel
---@param RayCastLength float
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindSurfaceFromEffectData(WorldContextObject, EffectData, HitResult, ActorsToIgnore, CollisionChannel, RayCastLength) end
---@param WorldContextObject UObject
---@param RequestedBlamAbsolutePlayerIndex int32
---@param OutPlayerState APlayerState
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindPlayerStateUsingBlamAbsolutePlayerIndex(WorldContextObject, RequestedBlamAbsolutePlayerIndex, OutPlayerState) end
---@param WorldContextObject UObject
---@param ResponseDataObjectClass UClass
---@param MaterialGameplayTag FGameplayTag
---@param PrimaryMapping UHaloMaterialResponseMapping
---@param OverrideMapping UHaloMaterialResponseMapping
---@param OutResponses TArray<UObject>
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindMaterialImpactResponseData(WorldContextObject, ResponseDataObjectClass, MaterialGameplayTag, PrimaryMapping, OverrideMapping, OutResponses) end
---@param WorldContextObject UObject
---@param ResponseDataObjectClass UClass
---@param MaterialGameplayTag FGameplayTag
---@param PrimaryMapping UHaloMaterialResponseMapping
---@param OverrideMapping UHaloMaterialResponseMapping
---@param OutResponse UObject
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindFirstMaterialImpactResponseData(WorldContextObject, ResponseDataObjectClass, MaterialGameplayTag, PrimaryMapping, OverrideMapping, OutResponse) end
---@param EffectData FBlamEffectData
---@param Name FName
---@param OutVector FBlamEffectVector
---@return EBlamHelperLibrarySearchOutcome
function UBlamSynchronizationHelperLibrary:FindEffectVectorByName(EffectData, Name, OutVector) end
---@param Actor AActor
---@param OtherActor AActor
---@return boolean
function UBlamSynchronizationHelperLibrary:ActorTeamIsTraitor(Actor, OtherActor) end
---@param Actor AActor
---@param OtherActor AActor
---@return boolean
function UBlamSynchronizationHelperLibrary:ActorTeamIsFriendly(Actor, OtherActor) end
---@param Actor AActor
---@param OtherActor AActor
---@return boolean
function UBlamSynchronizationHelperLibrary:ActorTeamIsEnemy(Actor, OtherActor) end
---@param Actor AActor
---@param OtherActor AActor
---@return boolean
function UBlamSynchronizationHelperLibrary:ActorTeamIsAlly(Actor, OtherActor) end


---@class UBlamTrackedActorsSaveGame : UBlamSaveGame
local UBlamTrackedActorsSaveGame = {}


---@class UBlamUnrealWorldSaveGame : UBlamSaveGame
---@field ActorState FBlamUnrealSavedState
---@field UnrealSaveGameSystems TMap<FName, UBlamSaveGame>
local UBlamUnrealWorldSaveGame = {}



---@class UHaloMaterialResponseDataAsset : UDataAsset
---@field ResponseDataArray TArray<UObject>
local UHaloMaterialResponseDataAsset = {}



---@class UHaloMaterialResponseHandler : UObject
local UHaloMaterialResponseHandler = {}

---@param InMaterialResponseData FHaloMaterialResponseData
function UHaloMaterialResponseHandler:BlueprintHandleMaterialResponse(InMaterialResponseData) end
---@param OutResponseTags FGameplayTagContainer
function UHaloMaterialResponseHandler:BlueprintGetSupportedResponseTags(OutResponseTags) end


---@class UHaloMaterialResponseMapping : UDataAsset
---@field ParentMapping UHaloMaterialResponseMapping
---@field DataAssetMap TMap<FGameplayTag, UHaloMaterialResponseDataAsset>
local UHaloMaterialResponseMapping = {}



---@class UHaloMaterialResponseSystemConfig : UDeveloperSettings
---@field DefaultMaterialHandlers TArray<FSoftClassPath>
---@field PhysicalSurfaceToGameplayTagTable FSoftObjectPath
local UHaloMaterialResponseSystemConfig = {}



---@class UHaloMaterialResponseWorldSubsystem : UWorldSubsystem
---@field RegisteredHandlers TSet<UHaloMaterialResponseHandler>
---@field PhysicalMaterialNameToGameplayTagDataTable UDataTable
local UHaloMaterialResponseWorldSubsystem = {}



---@class UScenarioInsertionPointAsset : UPrimaryDataAsset
---@field InsertionPoints TArray<FScenarioInsertionPoint>
local UScenarioInsertionPointAsset = {}



---@class UScenarioUserInterfaceObjectiveAsset : UPrimaryDataAsset
---@field Objectives TArray<FScenarioUserInterfaceObjective>
local UScenarioUserInterfaceObjectiveAsset = {}




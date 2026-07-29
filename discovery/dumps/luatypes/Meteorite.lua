---@meta

---@class AMeteoriteCharacter : ACharacter
---@field Mesh1P USkeletalMeshComponent
---@field FirstPersonCameraComponent UCameraComponent
---@field DefaultMappingContext UInputMappingContext
---@field JumpAction UInputAction
---@field MoveAction UInputAction
---@field LookAction UInputAction
---@field bHasRifle boolean
local AMeteoriteCharacter = {}

---@param bNewHasRifle boolean
function AMeteoriteCharacter:SetHasRifle(bNewHasRifle) end
---@return boolean
function AMeteoriteCharacter:GetHasRifle() end


---@class AMeteoriteGameMode : ABlamGameMode
local AMeteoriteGameMode = {}


---@class AMeteoriteHUD : ABlamHUD
---@field ReticleInfo FBlamReticleInfo
---@field AimAssistInfo FBlamAimAssistInfo
---@field InteractionInfo FBlamInteractionInfo
---@field ScriptedNavpoints TArray<FBlamScriptedNavpoint>
---@field HudScriptingInfo FBlamHudScripting
---@field GhostTarget FBlamTargetPoint
---@field TrackedTarget FBlamTrackedTarget
---@field PlayerTrainingInfo FBlamPlayerTraining
---@field PlayerRespawnInfo FBlamPlayerRespawn
---@field OutOfBoundsInfo FBlamGameEngineTimer
---@field GlobalHudData FBlamGlobalHud
---@field AutoAimTargetLevel float
---@field FadeColor FLinearColor
---@field FadeOpacity float
---@field ChangedAimAssistTargetDelegate FMeteoriteHUDChangedAimAssistTargetDelegate
---@field ChangedHeadshotStateDelegate FMeteoriteHUDChangedHeadshotStateDelegate
---@field ChangedErrorConeRadiusDelegate FMeteoriteHUDChangedErrorConeRadiusDelegate
---@field ChangeCountdownTimeDelegate FMeteoriteHUDChangeCountdownTimeDelegate
---@field ChangeCountdownStateDelegate FMeteoriteHUDChangeCountdownStateDelegate
---@field ChangedPrimaryInteractionProgressDelegate FMeteoriteHUDChangedPrimaryInteractionProgressDelegate
---@field ChangedPrimaryInteractionTextDelegate FMeteoriteHUDChangedPrimaryInteractionTextDelegate
---@field ChangedSecondaryInteractionProgressDelegate FMeteoriteHUDChangedSecondaryInteractionProgressDelegate
---@field ChangedSecondaryInteractionTextDelegate FMeteoriteHUDChangedSecondaryInteractionTextDelegate
---@field ChangedScriptedNavpointsDelegate FMeteoriteHUDChangedScriptedNavpointsDelegate
---@field ChangedPlayerTrainingDelegate FMeteoriteHUDChangedPlayerTrainingDelegate
---@field HudBannerMessageDelegate FMeteoriteHUDHudBannerMessageDelegate
---@field GhostTargetChangedDelegate FMeteoriteHUDGhostTargetChangedDelegate
---@field TrackedTargetChangedDelegate FMeteoriteHUDTrackedTargetChangedDelegate
---@field ChangedPlayerRespawnFailureDelegate FMeteoriteHUDChangedPlayerRespawnFailureDelegate
---@field ChangedPlayerRespawnViewedPlayerDelegate FMeteoriteHUDChangedPlayerRespawnViewedPlayerDelegate
---@field ChangedPlayerRespawnTimerDelegate FMeteoriteHUDChangedPlayerRespawnTimerDelegate
---@field ChangedOutOfBoundsTimerDelegate FMeteoriteHUDChangedOutOfBoundsTimerDelegate
---@field ChangedFadeColorDelegate FMeteoriteHUDChangedFadeColorDelegate
---@field ChangedFadeOpacityDelegate FMeteoriteHUDChangedFadeOpacityDelegate
local AMeteoriteHUD = {}

---@param NewValue FText
function AMeteoriteHUD:TextValueChanged__DelegateSignature(NewValue) end
---@param NewValue FName
function AMeteoriteHUD:NameValueChanged__DelegateSignature(NewValue) end
---@param NewValue int32
function AMeteoriteHUD:IntValueChanged__DelegateSignature(NewValue) end
---@param NewValue FText
---@param NewActor AActor
---@param NewAction EBlamInteractPromptButtonAction
---@param NewSeatType EBlamInteractPromptSeatType
function AMeteoriteHUD:InteractionTextChanged__DelegateSignature(NewValue, NewActor, NewAction, NewSeatType) end
---@param NewValue float
function AMeteoriteHUD:FloatValueChanged__DelegateSignature(NewValue) end
---@param NewValue float
function AMeteoriteHUD:FadeOpacityChanged__DelegateSignature(NewValue) end
---@param NewValue FLinearColor
function AMeteoriteHUD:FadeColorChanged__DelegateSignature(NewValue) end
---@param NewValue EBlamHudCountdownState
function AMeteoriteHUD:CountdownStateValueChanged__DelegateSignature(NewValue) end
---@param NewScriptedNavpoints TArray<FBlamScriptedNavpoint>
function AMeteoriteHUD:ChangedScriptedNavpoints__DelegateSignature(NewScriptedNavpoints) end
---@param NewValue APlayerState
function AMeteoriteHUD:ChangedPlayerRespawnViewedPlayer__DelegateSignature(NewValue) end
---@param NewValue EBlamPlayerRespawnFailure
function AMeteoriteHUD:ChangedPlayerRespawnFailure__DelegateSignature(NewValue) end
---@param NewActor AActor
---@param PreviousActor AActor
function AMeteoriteHUD:ChangedActor__DelegateSignature(NewActor, PreviousActor) end
---@param NewValue boolean
function AMeteoriteHUD:BoolValueChanged__DelegateSignature(NewValue) end
---@param NewValue FBlamTrackedTarget
function AMeteoriteHUD:BlamTrackedTargetChanged__DelegateSignature(NewValue) end
---@param NewValue FBlamTargetPoint
function AMeteoriteHUD:BlamTargetPointChanged__DelegateSignature(NewValue) end


---@class AMeteoritePlayerController : ABlamPlayerController
---@field InputAutomator UMeteoriteAutomatorComponent
local AMeteoritePlayerController = {}

---@param bEnabled boolean
function AMeteoritePlayerController:SetInputEnabled(bEnabled) end
---@param WorldContextObject UObject
---@param bPause boolean
function AMeteoritePlayerController:SetGameAndBlamPaused(WorldContextObject, bPause) end


---@class AMeteoritePlayerState : ABlamPlayerState
local AMeteoritePlayerState = {}


---@class AMeteoriteProjectile : AActor
---@field CollisionComp USphereComponent
---@field ProjectileMovement UProjectileMovementComponent
local AMeteoriteProjectile = {}

---@param HitComp UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param NormalImpulse FVector
---@param Hit FHitResult
function AMeteoriteProjectile:OnHit(HitComp, OtherActor, OtherComp, NormalImpulse, Hit) end


---@class ASwarmContainmentVolume : AActor
---@field BoxComponent UBoxComponent
local ASwarmContainmentVolume = {}



---@class ASwarmObstacleDynamicVolume : AActor
---@field SphereComponent USphereComponent
local ASwarmObstacleDynamicVolume = {}



---@class ASwarmObstacleManager : AActor
---@field SwarmActors TArray<AActor>
---@field Obstacles TArray<ASwarmObstacleVolume>
---@field DynamicObstacles TArray<ASwarmObstacleDynamicVolume>
---@field ContainmentVolumes TArray<ASwarmContainmentVolume>
local ASwarmObstacleManager = {}

---@param SwarmActor AActor
function ASwarmObstacleManager:UnsubscribeSwarmActor(SwarmActor) end
---@param Volume ASwarmContainmentVolume
function ASwarmObstacleManager:UnsetContainmentVolume(Volume) end
---@param Obstacle ASwarmObstacleVolume
function ASwarmObstacleManager:UnregisterObstacle(Obstacle) end
---@param Obstacle ASwarmObstacleDynamicVolume
function ASwarmObstacleManager:UnregisterDynamicObstacle(Obstacle) end
---@param SwarmActor AActor
function ASwarmObstacleManager:SubscribeSwarmActor(SwarmActor) end
---@param Volume ASwarmContainmentVolume
function ASwarmObstacleManager:SetContainmentVolume(Volume) end
---@param Obstacle ASwarmObstacleVolume
function ASwarmObstacleManager:RegisterObstacle(Obstacle) end
---@param Obstacle ASwarmObstacleDynamicVolume
function ASwarmObstacleManager:RegisterDynamicObstacle(Obstacle) end


---@class ASwarmObstacleVolume : AVolume
local ASwarmObstacleVolume = {}


---@class FAlertDataRow : FTableRowBase
---@field Title FText
---@field Message FText
local FAlertDataRow = {}



---@class FBlamAimAssistInfo
---@field TargetedActor AActor
---@field FullyTargetedActor AActor
---@field PrimaryAutoAimLevel float
---@field AutoAimFlags FBlamAutoAimFlags
local FBlamAimAssistInfo = {}



---@class FBlamGlobalHud
---@field HudCountdown FBlamHudCountdown
local FBlamGlobalHud = {}



---@class FBlamInteraction
---@field Message FText
---@field Progress float
---@field InteractionActor AActor
---@field Action EBlamInteractPromptButtonAction
---@field SeatType EBlamInteractPromptSeatType
local FBlamInteraction = {}



---@class FBlamInteractionInfo
---@field PrimaryInteraction FBlamInteraction
---@field SecondaryInteraction FBlamInteraction
local FBlamInteractionInfo = {}



---@class FBlamPlayerTraining
---@field TrainingName FName
local FBlamPlayerTraining = {}



---@class FBlamScriptedNavpoint
---@field Identifier int32
---@field Actor AActor
---@field bPositionedOnActor boolean
---@field OffsetWorldspace FVector
---@field Priority EBlamScriptedNavpointPriority
---@field Label FText
local FBlamScriptedNavpoint = {}



---@class FBlamTargetPoint
---@field bIsValid boolean
---@field PositionWorldspace FVector
local FBlamTargetPoint = {}



---@class FBlamTrackedTarget
---@field TargetPoint FBlamTargetPoint
---@field bIsLocked boolean
---@field LockingTheta float
local FBlamTrackedTarget = {}



---@class FBlamUserInterfaceObjectiveState
---@field ObjectiveName FText
---@field State EBlamUserInterfaceObjectiveState
local FBlamUserInterfaceObjectiveState = {}



---@class FBlamUserInterfaceObjectives
---@field ChangeType EBlamUserInterfaceObjectiveChangeType
---@field ObjectivesList TArray<FBlamUserInterfaceObjectiveState>
---@field bAllCompleted boolean
---@field bAllHidden boolean
local FBlamUserInterfaceObjectives = {}



---@class FCustomizationEntitlementRow : FTableRowBase
---@field SteamCode FString
---@field SteamStoreCode FString
---@field XboxCode FString
---@field XboxStoreCode FString
---@field PSNCode FString
---@field PSNStoreCode FString
---@field WaypointEntitlementName FString
local FCustomizationEntitlementRow = {}



---@class FDamageIndicatorDamageInstance
---@field DamageOwnerObject AActor
---@field DamageOrigin FVector
---@field Scale float
---@field BodyDamage float
---@field ShieldDamage float
---@field NormalizedDamage float
---@field NormalizedAccumulatedDamage float
---@field Yaw float
---@field LifeTime float
---@field CreationTime float
---@field EndTime float
local FDamageIndicatorDamageInstance = {}



---@class FDamageIndicatorInstances
---@field DamageInstances TArray<FDamageIndicatorDamageInstance>
local FDamageIndicatorInstances = {}



---@class FGameInfo
---@field bValid boolean
---@field CampaignDifficultyLevel EBlamCampaignDifficultyLevel
---@field ModifierPreset EModifierPresetSetting
---@field ActiveSkulls TSet<EBlamGameSkulls>
local FGameInfo = {}



---@class FGetLinkedAccountResult
---@field LinkedAccounts TArray<ULinkedAccount>
local FGetLinkedAccountResult = {}



---@class FInProgressDataRow : FTableRowBase
---@field Title FText
---@field Message FText
local FInProgressDataRow = {}



---@class FMeteoriteAccountAlias
---@field DisplayName FText
---@field PlatformId int32
local FMeteoriteAccountAlias = {}



---@class FPlayerNameRecord
---@field PlayerState APlayerState
---@field PlayerName FText
local FPlayerNameRecord = {}



---@class FRequiredSetting
---@field SettingTag FGameplayTag
---@field ComparisonType ESettingsValueComparison
---@field ComparisonValue int32
local FRequiredSetting = {}



---@class FResumeCampaignUIInfo
---@field SaveSlot EBlamGameModeSaveSlot
---@field Mission FString
---@field InsertionPoint FString
---@field Difficulty EBlamCampaignDifficultyLevel
local FResumeCampaignUIInfo = {}



---@class FRosterFriendInfo
---@field DisplayName FString
---@field Nickname FString
---@field PresenceStatus ERosterPresenceStatus
---@field RichPresenceString FString
---@field PlatformType ERosterFriendPlatformType
---@field IsJoinable boolean
local FRosterFriendInfo = {}



---@class FSaveSlotCampaignUIInfo
---@field SaveSlot EBlamGameModeSaveSlot
---@field Mission FText
---@field InsertionPoint FText
---@field Difficulty EBlamCampaignDifficultyLevel
---@field BlamCampaignType EBlamCampaignType
---@field TimestampUTC FDateTime
local FSaveSlotCampaignUIInfo = {}



---@class FScreenReaderRate
---@field Tag FGameplayTag
---@field Rate float
local FScreenReaderRate = {}



---@class FSettingsItemDataExtensionProperties
---@field RequiredSettings TArray<FRequiredSetting>
---@field UserIndex int32
local FSettingsItemDataExtensionProperties = {}



---@class FToastAsyncNodePair
---@field Key UMeteoriteToastInitData
---@field Value UMeteoriteToastAsyncNodeBase
local FToastAsyncNodePair = {}



---@class FVoiceChatFadeTimerSeconds
---@field Tag FGameplayTag
---@field Timer float
local FVoiceChatFadeTimerSeconds = {}



---@class IMeteoriteGetFriendsListPageInterface : IInterface
local IMeteoriteGetFriendsListPageInterface = {}

---@return UMeteoriteFriendsListPage
function IMeteoriteGetFriendsListPageInterface:GetMeteoriteFriendsListPage() end


---@class ISettingsItemDataExtension : IInterface
local ISettingsItemDataExtension = {}

---@param UserIndex int32
function ISettingsItemDataExtension:SetUserIndex(UserIndex) end
---@return boolean
function ISettingsItemDataExtension:HasAnyRequiredSettings() end
---@return UMeteoriteGameUserSettings
function ISettingsItemDataExtension:GetUserSettingsBP() end
---@return TArray<FName>
function ISettingsItemDataExtension:GetRequiredSettingNames() end


---@class UDebugMenuSettings : UDeveloperSettings
---@field bEnableDebugMenuBetaShipping boolean
---@field bEnableDebugMenuBetaNonShipping boolean
---@field bEnableDebugMenuReleaseShipping boolean
---@field bEnableDebugMenuReleaseNonShipping boolean
---@field bEnableDebugMenuDefaultShipping boolean
---@field bEnableDebugMenuDefaultNonShipping boolean
local UDebugMenuSettings = {}

---@return boolean
function UDebugMenuSettings:GetDebugMenuEnabled() end


---@class UGameFeedbackSettings : UDeveloperSettings
---@field bEnableGameFeedbackBetaShipping boolean
---@field bEnableGameFeedbackBetaNonShipping boolean
---@field bEnableGameFeedbackReleaseShipping boolean
---@field bEnableGameFeedbackReleaseNonShipping boolean
---@field bEnableGameFeedbackDefaultShipping boolean
---@field bEnableGameFeedbackDefaultNonShipping boolean
local UGameFeedbackSettings = {}

---@return boolean
function UGameFeedbackSettings:GetGameFeedbackEnabled() end


---@class UHudDataAsset : UPrimaryDataAsset
local UHudDataAsset = {}


---@class UHudDataAssetBanner : UHudDataAsset
---@field BannerMessageDelegate FHudDataAssetBannerBannerMessageDelegate
---@field PlayerLeftDelegate FHudDataAssetBannerPlayerLeftDelegate
local UHudDataAssetBanner = {}

---@param PlayerName FText
function UHudDataAssetBanner:OnPlayerLeft(PlayerName) end
---@param BannerMessage FText
function UHudDataAssetBanner:OnBannerMessageReceived(BannerMessage) end


---@class UHudDataAssetCountdown : UHudDataAsset
---@field TimeChangedDelegate FHudDataAssetCountdownTimeChangedDelegate
---@field StateChangedDelegate FHudDataAssetCountdownStateChangedDelegate
---@field CurrentState EBlamHudCountdownState
---@field NetworkedTime int32
---@field DisplayTime float
local UHudDataAssetCountdown = {}

---@param NewTime int32
function UHudDataAssetCountdown:OnChangedCountdownTime(NewTime) end
---@param NewState EBlamHudCountdownState
function UHudDataAssetCountdown:OnChangedCountdownState(NewState) end


---@class UHudDataAssetDirectionalDamage : UHudDataAsset
---@field DirectionalDamageDataChanged FHudDataAssetDirectionalDamageDirectionalDamageDataChanged
---@field DamageIndicatorInstances FDamageIndicatorInstances
---@field DefaultDuration float
---@field WeakLocalPlayerReference TWeakObjectPtr<ULocalPlayer>
local UHudDataAssetDirectionalDamage = {}

---@param PlayerEffect FBlamPlayerEffect
function UHudDataAssetDirectionalDamage:OnPlayerEffect(PlayerEffect) end
function UHudDataAssetDirectionalDamage:DataChanged__DelegateSignature() end


---@class UHudDataAssetEquipment : UHudDataAsset
---@field ChangedEquipmentDelegate FHudDataAssetEquipmentChangedEquipmentDelegate
---@field OnActivatedDelegate FHudDataAssetEquipmentOnActivatedDelegate
---@field OnWarmedUpDelegate FHudDataAssetEquipmentOnWarmedUpDelegate
---@field OnDeactivatedDelegate FHudDataAssetEquipmentOnDeactivatedDelegate
---@field OnStrengthDepletedDelegate FHudDataAssetEquipmentOnStrengthDepletedDelegate
---@field OnActiveFractionChangedDelegate FHudDataAssetEquipmentOnActiveFractionChangedDelegate
---@field CachedPreviousEquipment UBlamEquipmentComponent
local UHudDataAssetEquipment = {}

---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetEquipment:OnWarmedUp(BlamPropertyChangeReason) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetEquipment:OnStrengthDepleted(BlamPropertyChangeReason) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetEquipment:OnDeactivated(BlamPropertyChangeReason) end
---@param NewEquipment UBlamEquipmentComponent
---@param PreviousEquipment UBlamEquipmentComponent
function UHudDataAssetEquipment:OnChangedEquipment(NewEquipment, PreviousEquipment) end
---@param DeltaActiveFraction float
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetEquipment:OnActiveFractionChanged(DeltaActiveFraction, BlamPropertyChangeReason) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetEquipment:OnActivated(BlamPropertyChangeReason) end


---@class UHudDataAssetGrenadeCradle : UHudDataAsset
---@field ChangedInventoryDelegate FHudDataAssetGrenadeCradleChangedInventoryDelegate
---@field OnCurrentGrenadeChangedDelegate FHudDataAssetGrenadeCradleOnCurrentGrenadeChangedDelegate
---@field OnGrenadeCountChangedDelegate FHudDataAssetGrenadeCradleOnGrenadeCountChangedDelegate
local UHudDataAssetGrenadeCradle = {}

---@param NewInventory UBlamUnitInventoryComponent
---@param PreviousInventory UBlamUnitInventoryComponent
function UHudDataAssetGrenadeCradle:OnInventoryChanged(NewInventory, PreviousInventory) end
---@param GrenadeInventoryIndex int32
---@param DeltaCount int32
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetGrenadeCradle:OnGrenadeCountChanged(GrenadeInventoryIndex, DeltaCount, BlamPropertyChangeReason) end
---@param PreviousGrenadeInventoryIndex int32
---@param GrenadeInventoryIndex int32
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetGrenadeCradle:OnCurrentGrenadeChanged(PreviousGrenadeInventoryIndex, GrenadeInventoryIndex, BlamPropertyChangeReason) end


---@class UHudDataAssetInteractions : UHudDataAsset
---@field ChangedPrimaryInteractionProgressDelegate FHudDataAssetInteractionsChangedPrimaryInteractionProgressDelegate
---@field ChangedPrimaryInteractionTextDelegate FHudDataAssetInteractionsChangedPrimaryInteractionTextDelegate
---@field ChangedSecondaryInteractionProgressDelegate FHudDataAssetInteractionsChangedSecondaryInteractionProgressDelegate
---@field ChangedSecondaryInteractionTextDelegate FHudDataAssetInteractionsChangedSecondaryInteractionTextDelegate
local UHudDataAssetInteractions = {}

---@param NewValue FText
---@param NewActor AActor
---@param NewAction EBlamInteractPromptButtonAction
---@param NewSeatType EBlamInteractPromptSeatType
function UHudDataAssetInteractions:OnChangedSecondaryInteractionText(NewValue, NewActor, NewAction, NewSeatType) end
---@param NewValue float
function UHudDataAssetInteractions:OnChangedSecondaryInteractionProgress(NewValue) end
---@param NewValue FText
---@param NewActor AActor
---@param NewAction EBlamInteractPromptButtonAction
---@param NewSeatType EBlamInteractPromptSeatType
function UHudDataAssetInteractions:OnChangedPrimaryInteractionText(NewValue, NewActor, NewAction, NewSeatType) end
---@param NewValue float
function UHudDataAssetInteractions:OnChangedPrimaryInteractionProgress(NewValue) end


---@class UHudDataAssetNavpoints : UHudDataAsset
---@field ObjectivesNavpointWidgetClass TSubclassOf<UUserWidget>
---@field ObjectivesNavpointWidgetClassByPriority TMap<EBlamScriptedNavpointPriority, TSubclassOf<UUserWidget>>
---@field PlayerNavpointWidgetClass TSubclassOf<UUserWidget>
---@field GhostTargetWidgetClass TSubclassOf<UUserWidget>
---@field TrackedTargetWidgetClass TSubclassOf<UUserWidget>
---@field PinContainerName FName
---@field DeathDisplayTime double
---@field WeakLocalPlayerReference TWeakObjectPtr<ULocalPlayer>
local UHudDataAssetNavpoints = {}

---@param WidgetClass TSubclassOf<UUserWidget>
function UHudDataAssetNavpoints:SetTrackedTargetWidgetClass(WidgetClass) end
---@param TrackedTarget FBlamTrackedTarget
function UHudDataAssetNavpoints:SetTrackedTarget(TrackedTarget) end
---@param ScriptedNavpoints TArray<FBlamScriptedNavpoint>
function UHudDataAssetNavpoints:SetScriptedNavpoints(ScriptedNavpoints) end
---@param Priority EBlamScriptedNavpointPriority
---@param PriorityWidgetClass TSubclassOf<UUserWidget>
function UHudDataAssetNavpoints:SetPriorityWidgetClass(Priority, PriorityWidgetClass) end
---@param DistanceNear float
---@param DistanceFar float
---@param ScaleNear float
---@param ScaleFar float
function UHudDataAssetNavpoints:SetNavpointScaling(DistanceNear, DistanceFar, ScaleNear, ScaleFar) end
---@param WidgetClass TSubclassOf<UUserWidget>
function UHudDataAssetNavpoints:SetGhostTargetWidgetClass(WidgetClass) end
---@param TargetPoint FBlamTargetPoint
function UHudDataAssetNavpoints:SetGhostTarget(TargetPoint) end
---@param NewWeapon UBlamWeaponComponent
---@param PreviousWeapon UBlamWeaponComponent
function UHudDataAssetNavpoints:OnChangedPrimaryWeapon(NewWeapon, PreviousWeapon) end
---@return TSubclassOf<UUserWidget>
function UHudDataAssetNavpoints:GetTrackedTargetWidgetClass() end
---@return TSubclassOf<UUserWidget>
function UHudDataAssetNavpoints:GetGhostTargetWidgetClass() end


---@class UHudDataAssetNavpointsItemHighlights : UHudDataAsset
---@field ItemNavpointWidgetClass TSubclassOf<UUserWidget>
local UHudDataAssetNavpointsItemHighlights = {}

---@param DistanceNear float
---@param DistanceFar float
---@param ScaleNear float
---@param ScaleFar float
function UHudDataAssetNavpointsItemHighlights:SetNavpointScaling(DistanceNear, DistanceFar, ScaleNear, ScaleFar) end
---@param Overlaps TArray<FOverlapResult>
function UHudDataAssetNavpointsItemHighlights:ItemActorsChanged(Overlaps) end


---@class UHudDataAssetOutOfBounds : UHudDataAsset
---@field ChangedOutOfBoundsTimerDelegate FHudDataAssetOutOfBoundsChangedOutOfBoundsTimerDelegate
---@field OutOfBoundsInfo FBlamGameEngineTimer
local UHudDataAssetOutOfBounds = {}

---@param NewValue int32
function UHudDataAssetOutOfBounds:OnChangedOutOfBoundsTimer(NewValue) end


---@class UHudDataAssetPlayerRespawn : UHudDataAsset
---@field ChangedPlayerRespawnFailureDelegate FHudDataAssetPlayerRespawnChangedPlayerRespawnFailureDelegate
---@field ChangedPlayerRespawnTimerDelegate FHudDataAssetPlayerRespawnChangedPlayerRespawnTimerDelegate
---@field ChangedPlayerRespawnViewedPlayerDelegate FHudDataAssetPlayerRespawnChangedPlayerRespawnViewedPlayerDelegate
---@field PlayerRespawnInfo FBlamPlayerRespawn
local UHudDataAssetPlayerRespawn = {}

---@param NewValue APlayerState
function UHudDataAssetPlayerRespawn:OnChangedPlayerRespawnViewedPlayer(NewValue) end
---@param NewValue int32
function UHudDataAssetPlayerRespawn:OnChangedPlayerRespawnTimer(NewValue) end
---@param NewValue EBlamPlayerRespawnFailure
function UHudDataAssetPlayerRespawn:OnChangedPlayerRespawnFailure(NewValue) end


---@class UHudDataAssetReticle : UHudDataAsset
---@field ChangedUnitDelegate FHudDataAssetReticleChangedUnitDelegate
---@field ChangedWeaponDelegate FHudDataAssetReticleChangedWeaponDelegate
---@field ZoomLevelChangedDelegate FHudDataAssetReticleZoomLevelChangedDelegate
---@field RoundsLoadedChangedDelegate FHudDataAssetReticleRoundsLoadedChangedDelegate
---@field HeatChangedDelegate FHudDataAssetReticleHeatChangedDelegate
---@field BatteryChangedDelegate FHudDataAssetReticleBatteryChangedDelegate
---@field DamageDealtDelegate FHudDataAssetReticleDamageDealtDelegate
---@field ChangedErrorConeDelegate FHudDataAssetReticleChangedErrorConeDelegate
---@field ChangedAimAssistConeDelegate FHudDataAssetReticleChangedAimAssistConeDelegate
---@field OnChargeChangedDelegate FHudDataAssetReticleOnChargeChangedDelegate
---@field OnOverheatChangedDelegate FHudDataAssetReticleOnOverheatChangedDelegate
---@field OnRecoveryPercentageChangedDelegate FHudDataAssetReticleOnRecoveryPercentageChangedDelegate
---@field ChangedAimAssistTargetDelegate FHudDataAssetReticleChangedAimAssistTargetDelegate
---@field ChangedHeadshotStateDelegate FHudDataAssetReticleChangedHeadshotStateDelegate
---@field GhostTargetChangedDelegate FHudDataAssetReticleGhostTargetChangedDelegate
---@field OnCameraRotationChangedDelegate FHudDataAssetReticleOnCameraRotationChangedDelegate
---@field ErrorRatio float
---@field ErrorConeRadiusSlateUnits float
---@field MinConeRadiusSlateUnits float
---@field MaxConeRadiusSlateUnits float
---@field AimAssistConeRadiusSlateUnits float
---@field CameraPitchDegrees float
---@field CameraYawDegrees float
---@field WeakLocalPlayerReference TWeakObjectPtr<ULocalPlayer>
local UHudDataAssetReticle = {}

---@param DeltaOverheated float
function UHudDataAssetReticle:OnOverheatChanged__DelegateSignature(DeltaOverheated) end
---@param TargetPoint FBlamTargetPoint
function UHudDataAssetReticle:OnGhostTargetChanged(TargetPoint) end
---@param DamageAftermathResult FBlamDamageAftermathResult
function UHudDataAssetReticle:OnDamageDealt(DamageAftermathResult) end
---@param NewUnit UBlamUnitComponent
---@param PreviousUnit UBlamUnitComponent
function UHudDataAssetReticle:OnControlledUnitChanged(NewUnit, PreviousUnit) end
---@param TriggerIndex EBlamWeaponTrigger
---@param DeltaChargedFraction float
function UHudDataAssetReticle:OnChargeChanged__DelegateSignature(TriggerIndex, DeltaChargedFraction) end
---@param NewWeapon UBlamWeaponComponent
---@param PreviousWeapon UBlamWeaponComponent
function UHudDataAssetReticle:OnChangedPrimaryWeapon(NewWeapon, PreviousWeapon) end
---@param bNewValue boolean
function UHudDataAssetReticle:OnChangedHeadshotState(bNewValue) end
---@param NewActor AActor
---@param PreviousActor AActor
function UHudDataAssetReticle:OnChangedAimAssistTarget(NewActor, PreviousActor) end
---@param PitchDegrees float
---@param YawDegrees float
function UHudDataAssetReticle:OnCameraRotationChanged__DelegateSignature(PitchDegrees, YawDegrees) end
---@param ErrorRatio float
---@param ErrorConeRadiusSlateUnits float
---@param MinConeRadiusSlateUnits float
---@param MaxConeRadiusSlateUnits float
function UHudDataAssetReticle:ChangedErrorCone__DelegateSignature(ErrorRatio, ErrorConeRadiusSlateUnits, MinConeRadiusSlateUnits, MaxConeRadiusSlateUnits) end
---@param AimAssistConeRadiusSlateUnits float
function UHudDataAssetReticle:ChangedAimAssistCone__DelegateSignature(AimAssistConeRadiusSlateUnits) end
---@param NewValue FBlamTargetPoint
function UHudDataAssetReticle:BlamTargetPointChanged__DelegateSignature(NewValue) end


---@class UHudDataAssetVehicle : UHudDataAsset
---@field ChangedVehicleDelegate FHudDataAssetVehicleChangedVehicleDelegate
---@field ChangedVehicleUnitDelegate FHudDataAssetVehicleChangedVehicleUnitDelegate
---@field BoostPowerChangedDelegate FHudDataAssetVehicleBoostPowerChangedDelegate
local UHudDataAssetVehicle = {}

---@param NewVehicleUnit UBlamUnitComponent
---@param PreviousVehicleUnit UBlamUnitComponent
function UHudDataAssetVehicle:OnChangedVehicleUnit(NewVehicleUnit, PreviousVehicleUnit) end
---@param NewVehicle UBlamVehicleComponent
---@param PreviousVehicle UBlamVehicleComponent
function UHudDataAssetVehicle:OnChangedVehicle(NewVehicle, PreviousVehicle) end


---@class UHudDataAssetVitalityMeters : UHudDataAsset
---@field ChangedUnitDelegate FHudDataAssetVitalityMetersChangedUnitDelegate
---@field OnBodyDamagedDelegate FHudDataAssetVitalityMetersOnBodyDamagedDelegate
---@field OnShieldDamagedDelegate FHudDataAssetVitalityMetersOnShieldDamagedDelegate
---@field OnShieldDepletedDelegate FHudDataAssetVitalityMetersOnShieldDepletedDelegate
---@field OnShieldRechargeBeganDelegate FHudDataAssetVitalityMetersOnShieldRechargeBeganDelegate
---@field OnShieldRechargeCompletedDelegate FHudDataAssetVitalityMetersOnShieldRechargeCompletedDelegate
---@field OnBodyRechargeBeganDelegate FHudDataAssetVitalityMetersOnBodyRechargeBeganDelegate
---@field OnBodyRechargeCompletedDelegate FHudDataAssetVitalityMetersOnBodyRechargeCompletedDelegate
---@field OnPlayerDeadDelegate FHudDataAssetVitalityMetersOnPlayerDeadDelegate
---@field OnRecentBodyDamageChangedDelegate FHudDataAssetVitalityMetersOnRecentBodyDamageChangedDelegate
---@field OnRecentShieldDamageChangedDelegate FHudDataAssetVitalityMetersOnRecentShieldDamageChangedDelegate
---@field OnUpdateVitalityMetersDelegate FHudDataAssetVitalityMetersOnUpdateVitalityMetersDelegate
---@field RecentBodyDamageFalloffDelay float
---@field RecentBodyDamageFalloffTime float
---@field RecentShieldDamageFalloffDelay float
---@field RecentShieldDamageFalloffTime float
---@field RecentBodyDamage float
---@field RecentShieldDamage float
---@field DamageComponentRef UBlamObjectDamageComponent
---@field WeakLocalPlayerReference TWeakObjectPtr<ULocalPlayer>
local UHudDataAssetVitalityMeters = {}

function UHudDataAssetVitalityMeters:UpdateVitalityMeters__DelegateSignature() end
---@param NewUnit UBlamUnitComponent
---@param PreviousUnit UBlamUnitComponent
function UHudDataAssetVitalityMeters:OnUnitChanged(NewUnit, PreviousUnit) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetVitalityMeters:OnShieldRechargeCompleted(BlamPropertyChangeReason) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetVitalityMeters:OnShieldRechargeBegan(BlamPropertyChangeReason) end
function UHudDataAssetVitalityMeters:OnShieldDepleted__DelegateSignature() end
function UHudDataAssetVitalityMeters:OnShieldDepleted() end
---@param DeltaDamage float
function UHudDataAssetVitalityMeters:OnShieldDamaged(DeltaDamage) end
function UHudDataAssetVitalityMeters:OnRechargeCompleted__DelegateSignature() end
function UHudDataAssetVitalityMeters:OnRechargeBegan__DelegateSignature() end
---@param DeltaDamage float
function UHudDataAssetVitalityMeters:OnRecentShieldDamageChanged(DeltaDamage) end
---@param RecentDamage float
function UHudDataAssetVitalityMeters:OnRecentDamage__DelegateSignature(RecentDamage) end
---@param RecentDamage float
function UHudDataAssetVitalityMeters:OnRecentBodyDamageChanged(RecentDamage) end
function UHudDataAssetVitalityMeters:OnDead__DelegateSignature() end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetVitalityMeters:OnDead(BlamPropertyChangeReason) end
---@param DeltaDamage float
function UHudDataAssetVitalityMeters:OnDamaged__DelegateSignature(DeltaDamage) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetVitalityMeters:OnBodyRechargeCompleted(BlamPropertyChangeReason) end
---@param BlamPropertyChangeReason EBlamPropertyChangeReason
function UHudDataAssetVitalityMeters:OnBodyRechargeBegan(BlamPropertyChangeReason) end
---@param DeltaDamage float
function UHudDataAssetVitalityMeters:OnBodyDamaged(DeltaDamage) end


---@class UHudDataAssetWeaponCradle : UHudDataAsset
---@field ChangedInventoryDelegate FHudDataAssetWeaponCradleChangedInventoryDelegate
---@field ChangedPrimaryWeaponDelegate FHudDataAssetWeaponCradleChangedPrimaryWeaponDelegate
---@field ChangedBackpackWeaponDelegate FHudDataAssetWeaponCradleChangedBackpackWeaponDelegate
---@field RoundsLoadedChangedDelegate FHudDataAssetWeaponCradleRoundsLoadedChangedDelegate
---@field RoundsInventoryChangedDelegate FHudDataAssetWeaponCradleRoundsInventoryChangedDelegate
---@field BackpackRoundsInventoryChangedDelegate FHudDataAssetWeaponCradleBackpackRoundsInventoryChangedDelegate
---@field HeatChangedDelegate FHudDataAssetWeaponCradleHeatChangedDelegate
---@field BatteryChangedDelegate FHudDataAssetWeaponCradleBatteryChangedDelegate
---@field OnRecoveryPercentageChangedDelegate FHudDataAssetWeaponCradleOnRecoveryPercentageChangedDelegate
---@field WeaponSwap FHudDataAssetWeaponCradleWeaponSwap
---@field WeaponPickedUp FHudDataAssetWeaponCradleWeaponPickedUp
---@field WeaponDropped FHudDataAssetWeaponCradleWeaponDropped
---@field WeaponAllRemoved FHudDataAssetWeaponCradleWeaponAllRemoved
local UHudDataAssetWeaponCradle = {}

function UHudDataAssetWeaponCradle:WeaponSwap__DelegateSignature() end
function UHudDataAssetWeaponCradle:WeaponPickedUp__DelegateSignature() end
function UHudDataAssetWeaponCradle:WeaponDropped__DelegateSignature() end
function UHudDataAssetWeaponCradle:WeaponAllRemoved__DelegateSignature() end
---@param NewPrimaryWeapon UBlamWeaponComponent
---@param PreviousPrimaryWeapon UBlamWeaponComponent
---@param NewBackpackWeapon UBlamWeaponComponent
---@param PreviousBackpackWeapon UBlamWeaponComponent
function UHudDataAssetWeaponCradle:OnWeaponSetChanged(NewPrimaryWeapon, PreviousPrimaryWeapon, NewBackpackWeapon, PreviousBackpackWeapon) end
---@param NewInventory UBlamUnitInventoryComponent
---@param PreviousInventory UBlamUnitInventoryComponent
function UHudDataAssetWeaponCradle:OnInventoryChanged(NewInventory, PreviousInventory) end
---@param NewWeapon UBlamWeaponComponent
---@param PreviousWeapon UBlamWeaponComponent
function UHudDataAssetWeaponCradle:OnChangedPrimaryWeapon(NewWeapon, PreviousWeapon) end
---@param NewWeapon UBlamWeaponComponent
---@param PreviousWeapon UBlamWeaponComponent
function UHudDataAssetWeaponCradle:OnChangedBackpackWeapon(NewWeapon, PreviousWeapon) end


---@class UHudDataSubsystem : ULocalPlayerSubsystem
---@field ChangedUnit FHudDataSubsystemChangedUnit
---@field ChangedControlledUnit FHudDataSubsystemChangedControlledUnit
---@field ChangedInventory FHudDataSubsystemChangedInventory
---@field ChangedVehicle FHudDataSubsystemChangedVehicle
---@field ChangedPrimaryWeapon FHudDataSubsystemChangedPrimaryWeapon
---@field ChangedBackpackWeapon FHudDataSubsystemChangedBackpackWeapon
---@field ChangedWeaponSet FHudDataSubsystemChangedWeaponSet
---@field ChangedEquipment FHudDataSubsystemChangedEquipment
---@field ChangedFadeColor FHudDataSubsystemChangedFadeColor
---@field ChangedFadeOpacity FHudDataSubsystemChangedFadeOpacity
---@field PlayerJoinedDelegate FHudDataSubsystemPlayerJoinedDelegate
---@field PlayerLeftDelegate FHudDataSubsystemPlayerLeftDelegate
---@field PreviousUnit TWeakObjectPtr<UBlamUnitComponent>
---@field PreviousControlledUnit TWeakObjectPtr<UBlamUnitComponent>
---@field PreviousInventory TWeakObjectPtr<UBlamUnitInventoryComponent>
---@field PreviousVehicle TWeakObjectPtr<UBlamVehicleComponent>
---@field PreviousPrimaryWeapon TWeakObjectPtr<UBlamWeaponComponent>
---@field PreviousBackpackWeapon TWeakObjectPtr<UBlamWeaponComponent>
---@field PreviousEquipment TWeakObjectPtr<UBlamEquipmentComponent>
---@field FadeColor FLinearColor
---@field FadeOpacity float
---@field KnownPlayerNames TMap<int32, FPlayerNameRecord>
local UHudDataSubsystem = {}

---@param NewValue FText
function UHudDataSubsystem:PlayerNameChange__DelegateSignature(NewValue) end
---@param NewValue float
function UHudDataSubsystem:FadeOpacityChanged__DelegateSignature(NewValue) end
---@param NewValue FLinearColor
function UHudDataSubsystem:FadeColorChanged__DelegateSignature(NewValue) end
---@param NewPrimaryWeapon UBlamWeaponComponent
---@param PreviousPrimaryWeapon UBlamWeaponComponent
---@param NewBackpackWeapon UBlamWeaponComponent
---@param PreviousBackpackWeapon UBlamWeaponComponent
function UHudDataSubsystem:ChangedWeaponSet__DelegateSignature(NewPrimaryWeapon, PreviousPrimaryWeapon, NewBackpackWeapon, PreviousBackpackWeapon) end
---@param NewWeapon UBlamWeaponComponent
---@param PreviousWeapon UBlamWeaponComponent
function UHudDataSubsystem:ChangedWeapon__DelegateSignature(NewWeapon, PreviousWeapon) end
---@param NewVehicle UBlamVehicleComponent
---@param PreviousVehicle UBlamVehicleComponent
function UHudDataSubsystem:ChangedVehicle__DelegateSignature(NewVehicle, PreviousVehicle) end
---@param NewUnit UBlamUnitComponent
---@param PreviousUnit UBlamUnitComponent
function UHudDataSubsystem:ChangedUnit__DelegateSignature(NewUnit, PreviousUnit) end
---@param NewInventory UBlamUnitInventoryComponent
---@param PreviousInventory UBlamUnitInventoryComponent
function UHudDataSubsystem:ChangedInventory__DelegateSignature(NewInventory, PreviousInventory) end
---@param NewEquipment UBlamEquipmentComponent
---@param PreviousEquipment UBlamEquipmentComponent
function UHudDataSubsystem:ChangedEquipment__DelegateSignature(NewEquipment, PreviousEquipment) end


---@class UHudDebugDataSubsystem : UGameInstanceSubsystem
local UHudDebugDataSubsystem = {}

---@return FString
function UHudDebugDataSubsystem:GetDebugComputerName() end


---@class UHudGlobalDataSubsystem : UBlamGameInstanceSubsystem
---@field ObjectivesHudChangedDelegate FHudGlobalDataSubsystemObjectivesHudChangedDelegate
---@field ObjectivesMenuChangedDelegate FHudGlobalDataSubsystemObjectivesMenuChangedDelegate
---@field CinematicSkipDelegate FHudGlobalDataSubsystemCinematicSkipDelegate
---@field CinematicCutsceneTitleDelegate FHudGlobalDataSubsystemCinematicCutsceneTitleDelegate
---@field GameInfoChangedDelegate FHudGlobalDataSubsystemGameInfoChangedDelegate
---@field SystemUIWasActivatedDelegate FHudGlobalDataSubsystemSystemUIWasActivatedDelegate
---@field ObjectivesHud FBlamUserInterfaceObjectives
---@field ObjectivesMenu FBlamUserInterfaceObjectives
---@field GameInfo FGameInfo
local UHudGlobalDataSubsystem = {}

---@param NewValue FText
---@param NewValue2 FText
---@param NewValue3 FText
---@param TransitionType EBlamCutsceneTitleTransitionType
function UHudGlobalDataSubsystem:Text3ValueChanged__DelegateSignature(NewValue, NewValue2, NewValue3, TransitionType) end
function UHudGlobalDataSubsystem:SystemUIWasActivated__DelegateSignature() end
---@param ChangeReason EBlamUserInterfaceObjectiveChangeReason
function UHudGlobalDataSubsystem:ObjectivesChanged__DelegateSignature(ChangeReason) end
function UHudGlobalDataSubsystem:GameInfoChanged__DelegateSignature() end
---@param NewValue boolean
function UHudGlobalDataSubsystem:BoolValueChanged__DelegateSignature(NewValue) end


---@class UHudItemHighlightsSubsystem : ULocalPlayerSubsystem
---@field ItemActorsChangedDelegate FHudItemHighlightsSubsystemItemActorsChangedDelegate
---@field ItemHighlightsEnabledChangedDelegate FHudItemHighlightsSubsystemItemHighlightsEnabledChangedDelegate
---@field bItemHighlightsEnabled boolean
---@field CollisionSphere USphereComponent
local UHudItemHighlightsSubsystem = {}

---@param CollisionSphere USphereComponent
function UHudItemHighlightsSubsystem:SetCollisionSphere(CollisionSphere) end
---@param bEnabled boolean
function UHudItemHighlightsSubsystem:ItemHighlightsEnabledChanged__DelegateSignature(bEnabled) end
---@param Overlaps TArray<FOverlapResult>
function UHudItemHighlightsSubsystem:ItemActorsChanged__DelegateSignature(Overlaps) end


---@class UHudUserWidget : UHaloUIUserWidget
---@field HudDataAssets TArray<UHudDataAsset>
local UHudUserWidget = {}

function UHudUserWidget:InitializeHudDataAssets() end


---@class ULevelSelectorGenerator : UUserWidget
local ULevelSelectorGenerator = {}

---@return TArray<FString>
function ULevelSelectorGenerator:FindLevelNames() end


---@class ULinkedAccount : UObject
---@field LinkedPlatform ELinkedPlatform
---@field PlatformUserId FString
---@field DisplayName FString
local ULinkedAccount = {}



---@class UMeteoriteAccountSettingsWidget : UHaloUIActivatableWidget
---@field PrimaryName FText
---@field SecondaryNameList TArray<FMeteoriteAccountAlias>
local UMeteoriteAccountSettingsWidget = {}

function UMeteoriteAccountSettingsWidget:HandlePlayerDisplayNamesLoaded() end
---@param bErrorIsCausedByNoConnection boolean
function UMeteoriteAccountSettingsWidget:HandleErrorLoadingPlayerAliases(bErrorIsCausedByNoConnection) end


---@class UMeteoriteAutomatorComponent : UActorComponent
---@field AttachedController TWeakObjectPtr<AMeteoritePlayerController>
---@field CurrentActionIndex int32
local UMeteoriteAutomatorComponent = {}



---@class UMeteoriteFriendsListPage : UHaloUIActivatableWidget
---@field OnFriendsListUpdatedDelegate FMeteoriteFriendsListPageOnFriendsListUpdatedDelegate
---@field RosterStatusMessageTextBox UHaloUITextBlock
---@field FriendsList UHaloUIListView
---@field UILayer FGameplayTag
local UMeteoriteFriendsListPage = {}

function UMeteoriteFriendsListPage:OnFriendsListUpdated__DelegateSignature() end


---@class UMeteoriteGameInstance : UBlamGameInstance
local UMeteoriteGameInstance = {}

---@param bInProgress boolean
function UMeteoriteGameInstance:OnCinematicInProgress(bInProgress) end


---@class UMeteoriteGameUserSettings : UBlamGameUserSettings
---@field ScreenReaderEnabled boolean
---@field ScreenReaderRate FString
---@field ScreenReaderVolume float
---@field OnScreenReaderEnabledUpdated FMeteoriteGameUserSettingsOnScreenReaderEnabledUpdated
---@field GlobalTextSize FString
---@field HudTextSize FString
---@field SubtitleTextSize FString
---@field SplitscreenHudTextSize FString
---@field VoiceChatTextSize FString
---@field bSquadInvitesEnabled boolean
---@field VolumeMaster float
---@field VolumeMusicGameplay float
---@field VolumeMusicMenu float
---@field VolumeSFXAmbient float
---@field VolumeSFXGameplay float
---@field VolumeSFXMenu float
---@field VolumeVOChatter float
---@field VolumeVODialog float
---@field DynamicRange EAudioDynamicRange
---@field bTTSAndSTTEnabled boolean
---@field VoiceChatWidgetOpacity float
---@field VoiceChatBackgroundOpacity float
---@field VoiceChatInactiveWidgetOpacity float
---@field VoiceChatFadeTimerSeconds FString
---@field VoiceChatMode FString
---@field VoiceChatInputDeviceId FString
---@field VoiceChatOutputDeviceId FString
---@field VolumeVoiceChat float
---@field bCrossplay boolean
---@field FireteamSettings EAccountFireteamSetting
---@field AudioLanguage FString
---@field bItemHighlightsEnabled boolean
local UMeteoriteGameUserSettings = {}

---@param bNewValue boolean
function UMeteoriteGameUserSettings:SetScreenReaderEnabled(bNewValue) end
function UMeteoriteGameUserSettings:SaveHaloUserSettingsOperationCompleted() end
function UMeteoriteGameUserSettings:LoadHaloUserSettingsOperationCompleted() end
---@return boolean
function UMeteoriteGameUserSettings:GetSquadInvitesEnabled() end
---@param UserIndex int32
---@return UMeteoriteGameUserSettings
function UMeteoriteGameUserSettings:Get(UserIndex) end
---@param SettingValue FString
---@param SettingPropertyName FString
function UMeteoriteGameUserSettings:ApplySecondaryTextSizeBlueprint(SettingValue, SettingPropertyName) end
function UMeteoriteGameUserSettings:ApplyGlobalTextSizeBlueprint() end


---@class UMeteoriteGameViewportClient : UCommonGameViewportClient
local UMeteoriteGameViewportClient = {}


---@class UMeteoriteHudVisibility : UHaloUIHudVisibility
---@field PlayerControllerWeak TWeakObjectPtr<APlayerController>
local UMeteoriteHudVisibility = {}

---@param NewUnit UBlamUnitComponent
---@param PreviousUnit UBlamUnitComponent
function UMeteoriteHudVisibility:OnUnitChanged(NewUnit, PreviousUnit) end
function UMeteoriteHudVisibility:OnGameInfoChanged() end
---@param PlayerController APlayerController
function UMeteoriteHudVisibility:Initialize(PlayerController) end


---@class UMeteoriteInstallPSOProgressSubsystem : UGameInstanceSubsystem
---@field bProgressVisible boolean
---@field InstallProgress int64
---@field InstallTotal int64
---@field PSOProgress int64
---@field PSOTotal int64
---@field bWaitingForBlamExperience boolean
---@field ProgressVisibleChangedDelegate FMeteoriteInstallPSOProgressSubsystemProgressVisibleChangedDelegate
---@field InstallProgressChangedDelegate FMeteoriteInstallPSOProgressSubsystemInstallProgressChangedDelegate
---@field PSOProgressChangedDelegate FMeteoriteInstallPSOProgressSubsystemPSOProgressChangedDelegate
---@field InstallCompletedDelegate FMeteoriteInstallPSOProgressSubsystemInstallCompletedDelegate
---@field PSOCompletedDelegate FMeteoriteInstallPSOProgressSubsystemPSOCompletedDelegate
---@field WaitingForBlamExperienceChangedDelegate FMeteoriteInstallPSOProgressSubsystemWaitingForBlamExperienceChangedDelegate
local UMeteoriteInstallPSOProgressSubsystem = {}

function UMeteoriteInstallPSOProgressSubsystem:VideoSettingsWereChanged() end
---@param Numerator int64
---@param Denominator int64
function UMeteoriteInstallPSOProgressSubsystem:ProgressValueChanged__DelegateSignature(Numerator, Denominator) end
function UMeteoriteInstallPSOProgressSubsystem:ProgressCompleted__DelegateSignature() end
---@param NewValue boolean
function UMeteoriteInstallPSOProgressSubsystem:BoolValueChanged__DelegateSignature(NewValue) end


---@class UMeteoriteInviteToastInitData : UMeteoriteToastInitData
---@field OriginatingPlayerPlatformIconType PlatformIconType
local UMeteoriteInviteToastInitData = {}



---@class UMeteoriteLoadingScreenSubsystem : UGameInstanceSubsystem
---@field OnBlamPredictedTagLoadCountChanged FMeteoriteLoadingScreenSubsystemOnBlamPredictedTagLoadCountChanged
---@field OnBlamProgressLoadTagCountChanged FMeteoriteLoadingScreenSubsystemOnBlamProgressLoadTagCountChanged
---@field bUseLoadingScreen boolean
---@field bShowNonBlockingLoadScreenAfterBlockingLoad boolean
---@field NonBlockingLoadMinimumDisplayTime float
---@field DefaultNonBlockingLoadScreenClass TSoftClassPtr<UUserWidget>
---@field CurrentNonBlockingLoadScreenClass TSoftClassPtr<UUserWidget>
---@field NonBlockingLoadScreenUWidget TWeakObjectPtr<UUserWidget>
---@field CachedPredictedTagCount int32
---@field CachedLoadedTagCount int32
local UMeteoriteLoadingScreenSubsystem = {}

function UMeteoriteLoadingScreenSubsystem:ShowNonBlockingLoadScreen() end
---@param bValue boolean
function UMeteoriteLoadingScreenSubsystem:SetUseLoadingScreen(bValue) end
---@param bValue boolean
function UMeteoriteLoadingScreenSubsystem:SetShowNonBlockingLoadScreenAfterBlockingLoad(bValue) end
---@param InValue float
function UMeteoriteLoadingScreenSubsystem:SetNonBlockingLoadMinimumDisplayTime(InValue) end
---@param InScreen TSoftClassPtr<UUserWidget>
function UMeteoriteLoadingScreenSubsystem:SetDefaultNonBlockingLoadScreenClass(InScreen) end
---@param InScreen TSoftClassPtr<UUserWidget>
function UMeteoriteLoadingScreenSubsystem:SetCurrentNonBlockingLoadScreenClass(InScreen) end
---@param LoadedTagCount int32
function UMeteoriteLoadingScreenSubsystem:OnBlamProgressLoadTagCountChanged__DelegateSignature(LoadedTagCount) end
---@param PredictedTagCount int32
function UMeteoriteLoadingScreenSubsystem:OnBlamPredictedTagLoadCountChanged__DelegateSignature(PredictedTagCount) end
function UMeteoriteLoadingScreenSubsystem:HideNonBlockingLoadScreen() end
---@return boolean
function UMeteoriteLoadingScreenSubsystem:GetUseLoadingScreen() end
---@return boolean
function UMeteoriteLoadingScreenSubsystem:GetShowNonBlockingLoadScreenAfterBlockingLoad() end
---@return int32
function UMeteoriteLoadingScreenSubsystem:GetNonBlockingLoadScreenRefCount() end
---@return float
function UMeteoriteLoadingScreenSubsystem:GetNonBlockingLoadMinimumDisplayTime() end
---@return TSoftClassPtr<UUserWidget>
function UMeteoriteLoadingScreenSubsystem:GetDefaultNonBlockingLoadScreenClass() end
---@return TSoftClassPtr<UUserWidget>
function UMeteoriteLoadingScreenSubsystem:GetCurrentNonBlockingLoadScreenClass() end


---@class UMeteoriteLobbyAlertInitData : UHaloUIAlertInitData
local UMeteoriteLobbyAlertInitData = {}


---@class UMeteoriteLobbyBlueprintHelpers : UBlueprintFunctionLibrary
local UMeteoriteLobbyBlueprintHelpers = {}

---@return boolean
function UMeteoriteLobbyBlueprintHelpers:IsUserInActiveGame() end
---@return FString
function UMeteoriteLobbyBlueprintHelpers:GetLocalPlatformType() end
---@param ParentBox UHaloUISizeBox
---@param DropdownWidget UHaloUIActivatableWidget
function UMeteoriteLobbyBlueprintHelpers:AdjustDropdownPlacementBasedOnRelativeScrollPosition(ParentBox, DropdownWidget) end


---@class UMeteoriteLobbyNotifier : UGameInstanceSubsystem
---@field LobbyAlertClassDefault TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@field LobbyDialogClassDefault TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@field LobbyToastClassDefault TSubclassOf<UMeteoriteToastWidgetBase>
---@field InviteToastWidgetDefault TSubclassOf<UMeteoriteToastWidgetBase>
---@field LobbyNotificationLayer FGameplayTag
---@field RequestCancelCountdownDelegate FMeteoriteLobbyNotifierRequestCancelCountdownDelegate
local UMeteoriteLobbyNotifier = {}

---@param Value boolean
function UMeteoriteLobbyNotifier:SetXsapiLogoutAlertPending(Value) end
function UMeteoriteLobbyNotifier:RequestCancelCountdown__DelegateSignature() end
---@param InLobbyAlertDefaultClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@param InLobbyDialogDefaultClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@param InLobbyToastDefaultClass TSubclassOf<UMeteoriteToastWidgetBase>
---@param InInviteToastWidgetDefaultClass TSubclassOf<UMeteoriteToastWidgetBase>
---@param UILayer FGameplayTag
function UMeteoriteLobbyNotifier:InitializeLobbyWidgetInfo(InLobbyAlertDefaultClass, InLobbyDialogDefaultClass, InLobbyToastDefaultClass, InInviteToastWidgetDefaultClass, UILayer) end
---@param Result EHaloUIModalPopupResult
---@param InitData UHaloUIPopupInitData
function UMeteoriteLobbyNotifier:HandleUserSettingsConflictResult(Result, InitData) end
---@param NewConnectionState EInputDeviceConnectionState
---@param PlatformUserId FPlatformUserId
---@param InputDeviceId FInputDeviceId
function UMeteoriteLobbyNotifier:HandleOnInputDeviceConnectionChange(NewConnectionState, PlatformUserId, InputDeviceId) end
---@param Result EHaloUIModalPopupResult
---@param PopupInitData UHaloUIPopupInitData
function UMeteoriteLobbyNotifier:HandleDialogCompleted(Result, PopupInitData) end
---@return boolean
function UMeteoriteLobbyNotifier:GetXsapiLogoutAlertPending() end
function UMeteoriteLobbyNotifier:EndAllowInvites() end
function UMeteoriteLobbyNotifier:BeginAllowInvites() end
---@param ToastInitData UMeteoriteInviteToastInitData
function UMeteoriteLobbyNotifier:AcceptInvite(ToastInitData) end


---@class UMeteoriteLobbyNotifierDialogInitData : UHaloUIDialogInitData
local UMeteoriteLobbyNotifierDialogInitData = {}


---@class UMeteoriteLocalPlayer : UBlamLocalPlayer
local UMeteoriteLocalPlayer = {}


---@class UMeteoriteMenuStateSubsystem : UHaloUIMenuStateSubsystem
---@field OnWindowFocusChanged FMeteoriteMenuStateSubsystemOnWindowFocusChanged
---@field OnXsapiStart FMeteoriteMenuStateSubsystemOnXsapiStart
---@field OnXsapiEnd FMeteoriteMenuStateSubsystemOnXsapiEnd
---@field OnUnlinkAccountComplete FMeteoriteMenuStateSubsystemOnUnlinkAccountComplete
---@field OnLinkAccountComplete FMeteoriteMenuStateSubsystemOnLinkAccountComplete
---@field OnAccountLinkBackout FMeteoriteMenuStateSubsystemOnAccountLinkBackout
---@field OnLoginSucceededSimple FMeteoriteMenuStateSubsystemOnLoginSucceededSimple
---@field OnLoginFailedSimple FMeteoriteMenuStateSubsystemOnLoginFailedSimple
---@field StartButtonReleasedRequest FMeteoriteMenuStateSubsystemStartButtonReleasedRequest
---@field OnLoginSucceeded FMeteoriteMenuStateSubsystemOnLoginSucceeded
---@field OnLoginFailed FMeteoriteMenuStateSubsystemOnLoginFailed
local UMeteoriteMenuStateSubsystem = {}

---@param LocalUser ULocalPlayer
function UMeteoriteMenuStateSubsystem:UnlinkAndLogout(LocalUser) end
---@param LocalUserIndex int32
---@param OnLoginSucceeded FStartSplitScreenLoginOnLoginSucceeded
---@param OnLoginFailed FStartSplitScreenLoginOnLoginFailed
function UMeteoriteMenuStateSubsystem:StartSplitScreenLogin(LocalUserIndex, OnLoginSucceeded, OnLoginFailed) end
---@param LocalUserIndex int32
---@param OnLoginSucceeded FStartLoginOnLoginSucceeded
---@param OnLoginFailed FStartLoginOnLoginFailed
function UMeteoriteMenuStateSubsystem:StartLogin(LocalUserIndex, OnLoginSucceeded, OnLoginFailed) end
---@param LocalUser ULocalPlayer
---@param OutPlatformDisplayName FText
---@param OutLinkedAccountDisplayName FText
---@return boolean
function UMeteoriteMenuStateSubsystem:ResolveDisplayNames(LocalUser, OutPlatformDisplayName, OutLinkedAccountDisplayName) end
function UMeteoriteMenuStateSubsystem:RequestMainMenu() end
---@param Uri FString
---@param Code FString
function UMeteoriteMenuStateSubsystem:OnXsapiLoginStart__DelegateSignature(Uri, Code) end
---@param bWasCanceled boolean
---@param NativeAccountString FString
function UMeteoriteMenuStateSubsystem:OnXsapiLoginEnd__DelegateSignature(bWasCanceled, NativeAccountString) end
---@param bIsFocused boolean
function UMeteoriteMenuStateSubsystem:OnWindowFocusChanged__DelegateSignature(bIsFocused) end
---@param bSuccess boolean
---@param ErrorMessage FString
function UMeteoriteMenuStateSubsystem:OnUnlinkAccountComplete__DelegateSignature(bSuccess, ErrorMessage) end
---@param KeyEvent FKeyEvent
function UMeteoriteMenuStateSubsystem:OnStartButtonReleasedRequest__DelegateSignature(KeyEvent) end
function UMeteoriteMenuStateSubsystem:OnLoginSucceededMulticast__DelegateSignature() end
function UMeteoriteMenuStateSubsystem:OnLoginSucceeded__DelegateSignature() end
---@param FailureReason FString
function UMeteoriteMenuStateSubsystem:OnLoginFailedMulticast__DelegateSignature(FailureReason) end
---@param FailureReason FString
function UMeteoriteMenuStateSubsystem:OnLoginFailed__DelegateSignature(FailureReason) end
---@param bSuccess boolean
---@param ErrorMessage FString
function UMeteoriteMenuStateSubsystem:OnLinkAccountComplete__DelegateSignature(bSuccess, ErrorMessage) end
function UMeteoriteMenuStateSubsystem:OnAccountLinkBackout__DelegateSignature() end
---@param LocalUser ULocalPlayer
function UMeteoriteMenuStateSubsystem:MsaLogout(LocalUser) end
---@param LocalUser ULocalPlayer
function UMeteoriteMenuStateSubsystem:Logout(LocalUser) end
---@return boolean
function UMeteoriteMenuStateSubsystem:LoadSettingsAfterLogin() end
---@param LocalUser ULocalPlayer
function UMeteoriteMenuStateSubsystem:LinkAccount(LocalUser) end
---@return boolean
function UMeteoriteMenuStateSubsystem:IsPrimaryUserFullySignedInAndLinked() end
function UMeteoriteMenuStateSubsystem:HandleAccountLinkBackout() end
---@return FString
function UMeteoriteMenuStateSubsystem:GetAccountMsaSignInURLCode() end
---@return FString
function UMeteoriteMenuStateSubsystem:GetAccountMsaSignInURI() end
---@return FDateTime
function UMeteoriteMenuStateSubsystem:GetAccountMsaSignInCodeExpireTime() end
---@return FString
function UMeteoriteMenuStateSubsystem:GetAccountLinkingURLCode() end
---@return FString
function UMeteoriteMenuStateSubsystem:GetAccountLinkingURI() end
---@param LocalUser ULocalPlayer
function UMeteoriteMenuStateSubsystem:CancelLogin(LocalUser) end
---@return boolean
function UMeteoriteMenuStateSubsystem:AccountMsaSignInForLinking() end


---@class UMeteoriteMotionTrackerPlayerDataSubsystem : ULocalPlayerSubsystem
---@field ChangedPlayerRemainingLifetimeDelegate FMeteoriteMotionTrackerPlayerDataSubsystemChangedPlayerRemainingLifetimeDelegate
---@field ChangedPlayerCompassYawDelegate FMeteoriteMotionTrackerPlayerDataSubsystemChangedPlayerCompassYawDelegate
---@field MotionTrackerDataWrapper UHaloUIMotionTrackerDataWrapper
local UMeteoriteMotionTrackerPlayerDataSubsystem = {}

---@param VisibleSpeed float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetVisibleSpeed(VisibleSpeed) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetVisibleRange(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetVerticalDistanceThreshold(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetVerticalCutoffDistance(Value) end
---@param SelfActor AActor
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetSelfActor(SelfActor) end
---@param PlayerSneakSpeed float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetPlayerSneakSpeed(PlayerSneakSpeed) end
---@param LargeActorType TSubclassOf<AActor>
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetLargeActorType(LargeActorType) end
---@param LargeActorScale float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetLargeActorScale(LargeActorScale) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetDetectionRange(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetBlipSize(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetBlipLifetime(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetBelowDistance(Value) end
---@param Value float
function UMeteoriteMotionTrackerPlayerDataSubsystem:SetAboveDistance(Value) end
---@return float
function UMeteoriteMotionTrackerPlayerDataSubsystem:GetPlayerRemainingLifetime() end
---@return float
function UMeteoriteMotionTrackerPlayerDataSubsystem:GetPlayerCompassYaw() end
---@return UHaloUIMotionTrackerDataWrapper
function UMeteoriteMotionTrackerPlayerDataSubsystem:GetMotionTrackerData() end
---@param NewValue float
function UMeteoriteMotionTrackerPlayerDataSubsystem:FloatValueChanged__DelegateSignature(NewValue) end


---@class UMeteoriteMotionTrackerSharedDataSubsystem : UWorldSubsystem
local UMeteoriteMotionTrackerSharedDataSubsystem = {}

---@param Actor AActor
function UMeteoriteMotionTrackerSharedDataSubsystem:UntrackActor(Actor) end
---@param Actor AActor
function UMeteoriteMotionTrackerSharedDataSubsystem:TrackActor(Actor) end


---@class UMeteoriteNavigationSystem : UNavigationSystemV1
local UMeteoriteNavigationSystem = {}


---@class UMeteoritePlayerViewModel : UObject
---@field PlatformUserId FPlatformUserId
---@field DisplayName FString
---@field bIsLeader boolean
---@field PlatformType ERosterFriendPlatformType
---@field PlayerController APlayerController
---@field PlayerState APlayerState
---@field bIsMuted boolean
---@field MuteStateChangedDelegate FMeteoritePlayerViewModelMuteStateChangedDelegate
local UMeteoritePlayerViewModel = {}

function UMeteoritePlayerViewModel:ViewProfile() end
function UMeteoritePlayerViewModel:ToggleMute() end
function UMeteoritePlayerViewModel:RefreshMuteState() end
function UMeteoritePlayerViewModel:PromoteToLeader() end
---@param ViewModel UMeteoritePlayerViewModel
---@param bNowMuted boolean
function UMeteoritePlayerViewModel:OnMuteStateChanged__DelegateSignature(ViewModel, bNowMuted) end
function UMeteoritePlayerViewModel:LeaveFireteam() end
function UMeteoritePlayerViewModel:KickFromFireteam() end
---@return boolean
function UMeteoritePlayerViewModel:IsTalking() end
---@return boolean
function UMeteoritePlayerViewModel:IsMuted() end
---@return boolean
function UMeteoritePlayerViewModel:IsInGameplayState() end
---@return boolean
function UMeteoritePlayerViewModel:CanViewProfile() end
---@return boolean
function UMeteoritePlayerViewModel:CanToggleMute() end
---@return boolean
function UMeteoritePlayerViewModel:CanPromoteToLeader() end
---@return boolean
function UMeteoritePlayerViewModel:CanLeaveFireteam() end
---@return boolean
function UMeteoritePlayerViewModel:CanKickFromFireteam() end


---@class UMeteoritePresenceWorldSubsystem : UWorldSubsystem
local UMeteoritePresenceWorldSubsystem = {}


---@class UMeteoriteProfilePuckBase : UHaloUIViewButtonBase
---@field ProfileTrayClass TSoftClassPtr<UMeteoriteProfileTrayWidgetBase>
---@field PlayerData URosterFriendItemData
local UMeteoriteProfilePuckBase = {}

---@param NewPlayerData URosterFriendItemData
function UMeteoriteProfilePuckBase:SetProfileLink(NewPlayerData) end
function UMeteoriteProfilePuckBase:JoinOtherPlayer() end
function UMeteoriteProfilePuckBase:InviteOtherPlayer() end
---@return FText
function UMeteoriteProfilePuckBase:GetPresence() end
---@return FText
function UMeteoriteProfilePuckBase:GetNickname() end
---@return FText
function UMeteoriteProfilePuckBase:GetDisplayName() end
---@return UMeteoriteProfileTrayWidgetBase
function UMeteoriteProfilePuckBase:GenerateProfileTrayForPlayer() end


---@class UMeteoriteProfileTrayWidgetBase : UHaloUIActivatableWidget
---@field CanShowJoinFriendUpdatedDelegate FMeteoriteProfileTrayWidgetBaseCanShowJoinFriendUpdatedDelegate
---@field ActiveDisplayNameTextBlock UHaloUIRichTextBlock
---@field AlternateDisplayNameList UHaloUIStackBox
---@field AlertClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@field UILayer FGameplayTag
---@field RosterWidget UMeteoriteRosterWidgetBase
---@field PlayerInfo URosterFriendItemData
local UMeteoriteProfileTrayWidgetBase = {}

function UMeteoriteProfileTrayWidgetBase:ToggleMute() end
function UMeteoriteProfileTrayWidgetBase:RequestUpdateForCanJoinFriend() end
function UMeteoriteProfileTrayWidgetBase:RemoveFriend() end
function UMeteoriteProfileTrayWidgetBase:RedirectPlayerToOSSProfile() end
function UMeteoriteProfileTrayWidgetBase:JoinFriend() end
---@return boolean
function UMeteoriteProfileTrayWidgetBase:IsPlayerOnline() end
function UMeteoriteProfileTrayWidgetBase:InviteFriend() end
function UMeteoriteProfileTrayWidgetBase:HandlePlayerLinkEstablished() end
---@param AlternateNameList TArray<FText>
function UMeteoriteProfileTrayWidgetBase:HandleAlternativeNameListLoaded_BP(AlternateNameList) end
---@return FText
function UMeteoriteProfileTrayWidgetBase:GetPlayerStatus() end
---@param AlertDefaultClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@param UILayerSelection FGameplayTag
function UMeteoriteProfileTrayWidgetBase:DebugSetAlertClass(AlertDefaultClass, UILayerSelection) end
---@return boolean
function UMeteoriteProfileTrayWidgetBase:CanShowRemoveFriend() end
---@return boolean
function UMeteoriteProfileTrayWidgetBase:CanShowRedirectPlayerToOSSProfile() end
function UMeteoriteProfileTrayWidgetBase:CanShowJoinFriendUpdated__DelegateSignature() end
---@return ERosterJoinability
function UMeteoriteProfileTrayWidgetBase:CanShowJoinFriend() end
---@return boolean
function UMeteoriteProfileTrayWidgetBase:CanShowInviteFriend() end


---@class UMeteoriteRosterViewModel : ULocalPlayerSubsystem
---@field OnRosterConnectivityChanged FMeteoriteRosterViewModelOnRosterConnectivityChanged
---@field ActiveRosterWidget UMeteoriteRosterWidgetBase
---@field ActiveProfileTrayWidget UMeteoriteProfileTrayWidgetBase
local UMeteoriteRosterViewModel = {}

---@param IsOffline boolean
function UMeteoriteRosterViewModel:OnRosterConnectivityChanged__DelegateSignature(IsOffline) end
---@param PlatformUserId FPlatformUserId
---@return boolean
function UMeteoriteRosterViewModel:IsAnyFriendJoinable(PlatformUserId) end
---@return boolean
function UMeteoriteRosterViewModel:GetRosterOfflineModeEnabled() end


---@class UMeteoriteRosterWidgetBase : UHaloUIActivatableWidget
---@field FriendsListNavBar UHaloUINavBarWidget
---@field FriendsListPageSwitcher UCommonActivatableWidgetSwitcher
---@field DefaultPuckClass TSoftClassPtr<UMeteoriteProfilePuckBase>
---@field UILayer FGameplayTag
---@field OfflineMessage FText
---@field EmptyFriendsListMessage FText
---@field NoCrossplayFriendsListMessage FText
---@field ViewModelPtr UMeteoriteRosterViewModel
---@field PageList TArray<UMeteoriteFriendsListPage>
local UMeteoriteRosterWidgetBase = {}



---@class UMeteoriteSettingsConfig : UDeveloperSettings
---@field NamedRtpcs TMap<FName, FSoftObjectPath>
---@field DynamicRangeEvents TMap<EAudioDynamicRange, FSoftObjectPath>
---@field AlertsTable TSoftObjectPtr<UDataTable>
---@field AlertWidgetClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@field InProgressTable TSoftObjectPtr<UDataTable>
---@field InProgressWidgetClass TSoftClassPtr<UHaloUIModalPopupWidgetBase>
---@field EntitlementsTable TSoftObjectPtr<UDataTable>
---@field BlockingLoadScreenFlipbookTexture TSoftObjectPtr<UTexture2D>
---@field BlockingLoadScreenFlipbookMargin FMargin
---@field BlockingLoadScreenFlipbookTime float
---@field BlockingLoadScreenBGColor FLinearColor
---@field MicrosoftAccountLoginExpireTime FTimespan
---@field ScreenReaderRates TArray<FScreenReaderRate>
---@field FadeTimerSeconds TArray<FVoiceChatFadeTimerSeconds>
local UMeteoriteSettingsConfig = {}

---@param RateString FString
---@return float
function UMeteoriteSettingsConfig:GetScreenReaderRateForString(RateString) end
---@param RateTag FGameplayTag
---@return float
function UMeteoriteSettingsConfig:GetScreenReaderRateForGameplayTag(RateTag) end
---@return FTimespan
function UMeteoriteSettingsConfig:GetMicrosoftAccountLoginExpireTime() end
---@param TimerString FString
---@return float
function UMeteoriteSettingsConfig:GetFadeTimerSecondsForString(TimerString) end
---@param TimerTag FGameplayTag
---@return float
function UMeteoriteSettingsConfig:GetFadeTimerSecondsForGameplayTag(TimerTag) end


---@class UMeteoriteShowLoginUICallbackProxy : UBlueprintAsyncActionBase
---@field onSuccess FMeteoriteShowLoginUICallbackProxyOnSuccess
---@field onFailure FMeteoriteShowLoginUICallbackProxyOnFailure
---@field WorldContextObject UObject
local UMeteoriteShowLoginUICallbackProxy = {}

---@param WorldContextObject UObject
---@param ControllerIndex int32
---@return UMeteoriteShowLoginUICallbackProxy
function UMeteoriteShowLoginUICallbackProxy:ShowExternalLoginUI(WorldContextObject, ControllerIndex) end


---@class UMeteoriteSocialCacheSubsystem : UGameInstanceSubsystem
local UMeteoriteSocialCacheSubsystem = {}


---@class UMeteoriteSquadLobbyViewItemData : UHaloUIViewItemData
---@field FireteamRowType EMeteoriteSquadLobbyRowType
---@field PlayerViewModel UMeteoritePlayerViewModel
---@field BackingDataChangedDelegate FMeteoriteSquadLobbyViewItemDataBackingDataChangedDelegate
---@field TalkingStateChangedDelegate FMeteoriteSquadLobbyViewItemDataTalkingStateChangedDelegate
---@field VoiceStateChangedDelegate FMeteoriteSquadLobbyViewItemDataVoiceStateChangedDelegate
---@field VoiceIconState EVoiceParticipantIconState
---@field MuteDelegateBoundPlayerViewModel UMeteoritePlayerViewModel
local UMeteoriteSquadLobbyViewItemData = {}

---@param Item UMeteoriteSquadLobbyViewItemData
---@param NewState EVoiceParticipantIconState
function UMeteoriteSquadLobbyViewItemData:OnVoiceStateChanged__DelegateSignature(Item, NewState) end
---@param Item UMeteoriteSquadLobbyViewItemData
---@param bIsTalking boolean
function UMeteoriteSquadLobbyViewItemData:OnTalkingStateChanged__DelegateSignature(Item, bIsTalking) end
---@param InViewModel UMeteoritePlayerViewModel
---@param bNowMuted boolean
function UMeteoriteSquadLobbyViewItemData:HandleMuteStateChanged(InViewModel, bNowMuted) end
---@param Item UMeteoriteSquadLobbyViewItemData
function UMeteoriteSquadLobbyViewItemData:BackingDataChanged__DelegateSignature(Item) end


---@class UMeteoriteSquadLobbyViewModel : UGameInstanceSubsystem
---@field PlayerWidgetClass TSubclassOf<UUserWidget>
---@field SplitscreenWidgetClass TSubclassOf<UUserWidget>
---@field BlankWidgetClass TSubclassOf<UUserWidget>
---@field bOfferJoinSlots boolean
---@field SquadMembers TArray<UMeteoriteSquadLobbyViewItemData>
---@field BackingDataChangedDelegate FMeteoriteSquadLobbyViewModelBackingDataChangedDelegate
---@field CrossplayEnabledChangedDelegate FMeteoriteSquadLobbyViewModelCrossplayEnabledChangedDelegate
---@field SquadMemberTalkingStateChangedDelegate FMeteoriteSquadLobbyViewModelSquadMemberTalkingStateChangedDelegate
---@field OnSquadConnectivityChanged FMeteoriteSquadLobbyViewModelOnSquadConnectivityChanged
---@field OnReconnectAttemptFailed FMeteoriteSquadLobbyViewModelOnReconnectAttemptFailed
---@field OnSplitscreenStatusChanged FMeteoriteSquadLobbyViewModelOnSplitscreenStatusChanged
---@field TotalPlayerCountChangedDelegate FMeteoriteSquadLobbyViewModelTotalPlayerCountChangedDelegate
---@field TotalPlayerCount int32
---@field bCrossPlayEnabled boolean
local UMeteoriteSquadLobbyViewModel = {}

---@param NewCount int32
function UMeteoriteSquadLobbyViewModel:TotalPlayerCountChanged__DelegateSignature(NewCount) end
---@param InClass TSubclassOf<UUserWidget>
function UMeteoriteSquadLobbyViewModel:SetSplitscreenWidgetClass(InClass) end
---@param Item UMeteoriteSquadLobbyViewItemData
---@param bIsTalking boolean
function UMeteoriteSquadLobbyViewModel:OnSquadMemberTalkingStateChanged__DelegateSignature(Item, bIsTalking) end
---@param IsOffline boolean
function UMeteoriteSquadLobbyViewModel:OnSquadConnectivityChanged__DelegateSignature(IsOffline) end
---@param ShouldActivateSquadWidget boolean
function UMeteoriteSquadLobbyViewModel:OnSplitscreenStatusChanged__DelegateSignature(ShouldActivateSquadWidget) end
function UMeteoriteSquadLobbyViewModel:OnReconnectAttemptFailed__DelegateSignature() end
---@param bEnabled boolean
function UMeteoriteSquadLobbyViewModel:OnCrossplayEnabledChanged__DelegateSignature(bEnabled) end
---@param Item UMeteoriteSquadLobbyViewItemData
---@param bIsTalking boolean
function UMeteoriteSquadLobbyViewModel:HandleItemTalkingStateChanged(Item, bIsTalking) end
---@param NewConnectionState EInputDeviceConnectionState
---@param PlatformUserId FPlatformUserId
---@param InputDeviceId FInputDeviceId
function UMeteoriteSquadLobbyViewModel:HandleInputDeviceConnectionChange(NewConnectionState, PlatformUserId, InputDeviceId) end
---@return int32
function UMeteoriteSquadLobbyViewModel:GetNumSquadMembers() end
---@return boolean
function UMeteoriteSquadLobbyViewModel:CheckIsOffline() end
---@return boolean
function UMeteoriteSquadLobbyViewModel:CanAddSplitscreenPlayer() end
function UMeteoriteSquadLobbyViewModel:BackingDataChanged__DelegateSignature() end


---@class UMeteoriteSquadVoiceViewItemData : UHaloUIViewItemData
---@field PlayerViewModel UMeteoritePlayerViewModel
---@field bHasValidPlayer boolean
local UMeteoriteSquadVoiceViewItemData = {}



---@class UMeteoriteSquadVoiceViewModel : UGameInstanceSubsystem
---@field BackingDataChangedDelegate FMeteoriteSquadVoiceViewModelBackingDataChangedDelegate
---@field PlayerWidgetClass TSubclassOf<UUserWidget>
---@field SquadMembers TArray<UMeteoriteSquadVoiceViewItemData>
local UMeteoriteSquadVoiceViewModel = {}

function UMeteoriteSquadVoiceViewModel:BackingDataChanged__DelegateSignature() end


---@class UMeteoriteSquadWidgetBase : UHaloUIActivatableWidget
---@field SquadStack UHaloUIStackBox
---@field SquadPlayerComponentWidgetClass TSoftClassPtr<UHaloUIActivatableWidget>
local UMeteoriteSquadWidgetBase = {}

---@param NewSquadPlayerWidget UHaloUIActivatableWidget
---@param SquadPlayerController APlayerController
---@param SquadPlayerDisplayName FText
---@param bIsSquadLeader boolean
---@param OEPlatformIdx int32
function UMeteoriteSquadWidgetBase:UpdateUIBySquadPlayerInfo(NewSquadPlayerWidget, SquadPlayerController, SquadPlayerDisplayName, bIsSquadLeader, OEPlatformIdx) end
---@param NewClassType TSoftClassPtr<UHaloUIActivatableWidget>
function UMeteoriteSquadWidgetBase:SetSquadPlayerComponentWidgetClass(NewClassType) end


---@class UMeteoriteTextChatWidgetBase : UHaloUIActivatableWidget
---@field BP_OnChatFocusActivated FMeteoriteTextChatWidgetBaseBP_OnChatFocusActivated
---@field BP_OnChatFocusDeactivated FMeteoriteTextChatWidgetBaseBP_OnChatFocusDeactivated
---@field ScrollBox UScrollBox
---@field MessageList UHaloUIVerticalBox
---@field InputTxt UHaloUITextEntry
---@field ChatContainer UHaloUISizeBox
---@field BackgroundWidget UHaloUIBorder
---@field ChatDescription UHaloUIRichTextBlock
---@field FullWidget UHaloUIOverlay
---@field TextStyleClass TSubclassOf<UCommonTextStyle>
---@field SendAction UInputAction
---@field ClearAction UInputAction
---@field bAutoScroll boolean
---@field FadeTimerSeconds float
---@field LengthOfFadeOutTimeSeconds float
---@field InactiveWidgetOpacity float
---@field NormalTextColor FLinearColor
---@field PartialTranscriptionColor FLinearColor
---@field FinalTranscriptionColor FLinearColor
---@field InputFontSize int32
---@field InputBackgroundColor FLinearColor
---@field InputBackgroundFocusedColor FLinearColor
---@field WidthFraction float
---@field HeightFraction float
---@field ViewportMargin FMargin
---@field bUseGlobalViewportForSizing boolean
---@field MinPixelWidth int32
---@field bLogInitialSizingDiagnostics boolean
---@field bBottomAnchorMessages boolean
---@field AbsoluteWidthDebugOverride float
---@field bWrapInputInRuntimeSizeBox boolean
---@field bCompensateForViewportDPIScale boolean
---@field bFractionsUseFullWindow boolean
---@field bRespectDesignSurfaceAspect boolean
---@field TargetDesignSurfaceAspect float
---@field bAllowMouseClickToActivate boolean
---@field bAutoExitAfterSend boolean
---@field bIsInteractive boolean
---@field bForceWidgetActive boolean
---@field DecoratorClasses TArray<TSubclassOf<URichTextBlockDecorator>>
---@field CachedVoiceSubsystem UMeteoriteVoiceSubsystem
---@field CachedRosterViewModel UMeteoriteRosterViewModel
---@field TopSlackSpacer UHaloUISizeBox
---@field InputWidthBox UHaloUISizeBox
local UMeteoriteTextChatWidgetBase = {}

function UMeteoriteTextChatWidgetBase:WasManuallyScrolled() end
function UMeteoriteTextChatWidgetBase:ToggleChatFocus() end
function UMeteoriteTextChatWidgetBase:ShowChatWidget() end
---@param Value boolean
function UMeteoriteTextChatWidgetBase:SetIsInteractive(Value) end
---@param Value float
function UMeteoriteTextChatWidgetBase:SetCurrentInactiveWidgetOpacity(Value) end
---@param Value float
function UMeteoriteTextChatWidgetBase:SetCurrentFullWidgetOpacity(Value) end
---@param Value float
function UMeteoriteTextChatWidgetBase:SetCurrentFadeTimerSeconds(Value) end
---@param Value float
function UMeteoriteTextChatWidgetBase:SetCurrentBackingWidgetOpacity(Value) end
---@return boolean
function UMeteoriteTextChatWidgetBase:SendCurrentInput() end
function UMeteoriteTextChatWidgetBase:RefreshDisplayNamesFromRoster() end
function UMeteoriteTextChatWidgetBase:HideChatWidget() end
---@param Text FText
---@param CommitMethod ETextCommit::Type
function UMeteoriteTextChatWidgetBase:HandleInputTextCommitted(Text, CommitMethod) end
---@param Text FText
function UMeteoriteTextChatWidgetBase:HandleInputTextChanged(Text) end
---@param Value boolean
function UMeteoriteTextChatWidgetBase:ForceWidgetActive(Value) end
function UMeteoriteTextChatWidgetBase:DeactivateChatFocus() end
---@param Value FString
---@param bTTS boolean
---@param bSTT boolean
function UMeteoriteTextChatWidgetBase:ApplyVoiceChatMode(Value, bTTS, bSTT) end
function UMeteoriteTextChatWidgetBase:ActivateChatFocus() end


---@class UMeteoriteToastAsyncNodeBase : UBlueprintAsyncActionBase
---@field OnResult FMeteoriteToastAsyncNodeBaseOnResult
---@field ToastSystem UMeteoriteToastSubsystem
---@field InitData UMeteoriteToastInitData
local UMeteoriteToastAsyncNodeBase = {}

---@param ToastSystemPtr UMeteoriteToastSubsystem
function UMeteoriteToastAsyncNodeBase:SetToastSystemPtr(ToastSystemPtr) end
---@param Title FText
---@param WidgetClass TSubclassOf<UMeteoriteToastWidgetBase>
---@param TargetPlayerPlatformId FPlatformUserId
function UMeteoriteToastAsyncNodeBase:QueueToast(Title, WidgetClass, TargetPlayerPlatformId) end
---@param Result EToastResult
function UMeteoriteToastAsyncNodeBase:HandleToastAction(Result) end
---@param InWorldContextObject UObject
---@param InInitData UMeteoriteToastInitData
---@return UMeteoriteToastAsyncNodeBase
function UMeteoriteToastAsyncNodeBase:CreateMeteoriteToastFromInitData(InWorldContextObject, InInitData) end


---@class UMeteoriteToastInitData : UObject
---@field Title FText
---@field WidgetClass TSubclassOf<UMeteoriteToastWidgetBase>
---@field TargetPlayerPlatformId FPlatformUserId
local UMeteoriteToastInitData = {}



---@class UMeteoriteToastSubsystem : UGameInstanceSubsystem
---@field ToastQueue TArray<FToastAsyncNodePair>
local UMeteoriteToastSubsystem = {}



---@class UMeteoriteToastWidgetBase : UHaloUIActivatableWidget
---@field TitleTextBox UHaloUITextBlock
---@field InitData UMeteoriteToastInitData
---@field AsyncNode UMeteoriteToastAsyncNodeBase
local UMeteoriteToastWidgetBase = {}

---@param Result EToastResult
function UMeteoriteToastWidgetBase:ToastAction(Result) end


---@class UMeteoriteUIBlueprintLibrary : UBlueprintFunctionLibrary
local UMeteoriteUIBlueprintLibrary = {}

---@param PlayerController APlayerController
---@param InputAction UInputAction
---@return boolean
function UMeteoriteUIBlueprintLibrary:IsInputActionACurrentlyActiveBinding(PlayerController, InputAction) end
---@param Icon PlatformIconType
---@param OutputIconString FString
function UMeteoriteUIBlueprintLibrary:GetPlatformImageString(Icon, OutputIconString) end
---@param WorldContextObject UObject
function UMeteoriteUIBlueprintLibrary:AttemptReconnection(WorldContextObject) end
---@param PlayerController APlayerController
---@param bFront boolean
---@param OutputIconGamertagString FString
---@return FString
function UMeteoriteUIBlueprintLibrary:AppendPlatformImageStringToGamertagFromPlayerController(PlayerController, bFront, OutputIconGamertagString) end
---@param Icon PlatformIconType
---@param bFront boolean
---@param OutputIconGamertagString FString
---@return FString
function UMeteoriteUIBlueprintLibrary:AppendPlatformImageStringToGamertag(Icon, bFront, OutputIconGamertagString) end


---@class UMeteoriteUILinkedAccountsAsyncAction : UBlueprintAsyncActionBase
---@field OnResult FMeteoriteUILinkedAccountsAsyncActionOnResult
---@field OnError FMeteoriteUILinkedAccountsAsyncActionOnError
local UMeteoriteUILinkedAccountsAsyncAction = {}

---@param InWorldContextObject UObject
---@param PlayerController APlayerController
---@return UMeteoriteUILinkedAccountsAsyncAction
function UMeteoriteUILinkedAccountsAsyncAction:GetLinkedAccounts(InWorldContextObject, PlayerController) end


---@class UMeteoriteUISaveSlotCampaignUIInfoAsyncAction : UBlueprintAsyncActionBase
---@field OnResult FMeteoriteUISaveSlotCampaignUIInfoAsyncActionOnResult
---@field OnError FMeteoriteUISaveSlotCampaignUIInfoAsyncActionOnError
local UMeteoriteUISaveSlotCampaignUIInfoAsyncAction = {}

---@param InWorldContextObject UObject
---@param PlayerController APlayerController
---@param RequestedSaveSlot EBlamGameModeSaveSlot
---@return UMeteoriteUISaveSlotCampaignUIInfoAsyncAction
function UMeteoriteUISaveSlotCampaignUIInfoAsyncAction:GetSaveSlotCampaignUIInfoAsync(InWorldContextObject, PlayerController, RequestedSaveSlot) end
---@param InWorldContextObject UObject
---@param PlayerController APlayerController
---@return UMeteoriteUISaveSlotCampaignUIInfoAsyncAction
function UMeteoriteUISaveSlotCampaignUIInfoAsyncAction:GetLatestSaveSlotCampaignUIInfoAsync(InWorldContextObject, PlayerController) end


---@class UMeteoriteUIStatics : UBlueprintFunctionLibrary
local UMeteoriteUIStatics = {}

---@param InBlamActor ABlamObjectActor
---@return APlayerController
function UMeteoriteUIStatics:TryAndGetLocalPlayerControllerForBlamObjectActor(InBlamActor) end
---@param PlayerController APlayerController
---@param EntitlementName FName
function UMeteoriteUIStatics:ShowStore(PlayerController, EntitlementName) end
---@param LocalUserIndex int32
---@param bEnabled boolean
function UMeteoriteUIStatics:SetPlatformMouseCursorEnabled(LocalUserIndex, bEnabled) end
---@param PlayerController APlayerController
---@param SkinName FGameplayTag
function UMeteoriteUIStatics:SetEquippedObjectSkin(PlayerController, SkinName) end
---@param bEnabled boolean
function UMeteoriteUIStatics:SetDifficultyModifiersEnabled(bEnabled) end
---@param PlayerController APlayerController
---@param OnSaveCompleted FSaveEquippedSkinSelectionsOnSaveCompleted
function UMeteoriteUIStatics:SaveEquippedSkinSelections(PlayerController, OnSaveCompleted) end
---@param PlayerController APlayerController
function UMeteoriteUIStatics:ResumeRemixSave(PlayerController) end
---@param PlayerController APlayerController
function UMeteoriteUIStatics:ResumeDLCSave(PlayerController) end
---@param PlayerController APlayerController
function UMeteoriteUIStatics:ResumeCampaignSave(PlayerController) end
---@param PlayerController APlayerController
function UMeteoriteUIStatics:RequestWaypointEntitlements(PlayerController) end
---@param WorldContextObject UObject
---@param EntitlementName FName
---@return boolean
function UMeteoriteUIStatics:IsWaypointEntitlement(WorldContextObject, EntitlementName) end
---@return boolean
function UMeteoriteUIStatics:IsShippingBuild() end
---@param PlayerState APlayerState
---@return boolean
function UMeteoriteUIStatics:IsReadyForGameplay(PlayerState) end
---@param WorldContextObject UObject
---@param EntitlementName FName
---@return boolean
function UMeteoriteUIStatics:IsPurchasableEntitlement(WorldContextObject, EntitlementName) end
---@param PlayerController APlayerController
---@param ProgressionTag FGameplayTag
---@return boolean
function UMeteoriteUIStatics:IsProgressionGameplayTagPresent(PlayerController, ProgressionTag) end
---@param PlayerController APlayerController
---@param ScenarioRow FBlamScenarioDataTableRow
---@return boolean
function UMeteoriteUIStatics:IsMissionLocked(PlayerController, ScenarioRow) end
---@param PlayerController APlayerController
---@param ScenarioRow FBlamScenarioDataTableRow
---@param InsertionPointIndex int32
---@return boolean
function UMeteoriteUIStatics:IsInsertionPointLocked(PlayerController, ScenarioRow, InsertionPointIndex) end
---@param WorldContextObject UObject
---@return boolean
function UMeteoriteUIStatics:IsInGameplayState(WorldContextObject) end
---@return boolean
function UMeteoriteUIStatics:IsHDRSupportedAndAllowed() end
---@param PlayerController APlayerController
---@param EntitlementName FName
---@return boolean
function UMeteoriteUIStatics:IsDLCPurchased(PlayerController, EntitlementName) end
---@param PlayerController APlayerController
---@return boolean
function UMeteoriteUIStatics:HasValidCurrentSavedGameIndex(PlayerController) end
---@param LocalUserIndex int32
---@return FPlatformUserId
function UMeteoriteUIStatics:GetPlatformUserIdFromLocalUserIndex(LocalUserIndex) end
---@param PlayerController APlayerController
---@return EBlamGameModeSaveSlot
function UMeteoriteUIStatics:GetLastSavedGameMode(PlayerController) end
---@param PlayerController APlayerController
---@param ObjectOrSkinName FGameplayTag
---@return FGameplayTag
function UMeteoriteUIStatics:GetEquippedObjectSkin(PlayerController, ObjectOrSkinName) end
---@return boolean
function UMeteoriteUIStatics:GetDifficultyModifiersEnabled() end
---@return FString
function UMeteoriteUIStatics:GetBuildDateString() end
---@return FString
function UMeteoriteUIStatics:GetBuildChangelist() end
---@param TerminalName FName
---@return boolean
function UMeteoriteUIStatics:Debug_IsTerminalLocked(TerminalName) end
---@param GameSkull EBlamGameSkulls
---@return boolean
function UMeteoriteUIStatics:Debug_IsSkullLocked(GameSkull) end
---@param TextA FText
---@param TextB FText
---@return int32
function UMeteoriteUIStatics:CompareFText(TextA, TextB) end
---@param PlayerController APlayerController
function UMeteoriteUIStatics:CheckAndNotifyForCrossplayPrivileges(PlayerController) end
---@param PlayerController APlayerController
---@param SaveSlot EBlamGameModeSaveSlot
---@return boolean
function UMeteoriteUIStatics:CanResumeSaveSlot(PlayerController, SaveSlot) end
---@param PlayerController APlayerController
---@return boolean
function UMeteoriteUIStatics:CanResumeRemixSave(PlayerController) end
---@param PlayerController APlayerController
---@return boolean
function UMeteoriteUIStatics:CanResumeDLCSave(PlayerController) end
---@param PlayerController APlayerController
---@return boolean
function UMeteoriteUIStatics:CanResumeCampaignSave(PlayerController) end


---@class UMeteoriteViewportHoldLocalPlayerSubsystem : ULocalPlayerSubsystem
local UMeteoriteViewportHoldLocalPlayerSubsystem = {}

---@param OldPawn APawn
---@param NewPawn APawn
function UMeteoriteViewportHoldLocalPlayerSubsystem:OnPossessedPawnChangedCallback(OldPawn, NewPawn) end
---@param PreviousUnitActor AActor
---@param NewUnitActor AActor
function UMeteoriteViewportHoldLocalPlayerSubsystem:OnBlamPawnUnitChangedCallback(PreviousUnitActor, NewUnitActor) end


---@class UMeteoriteXboxNonPrimaryControllerSubsystem : UGameInstanceSubsystem
local UMeteoriteXboxNonPrimaryControllerSubsystem = {}


---@class UPendingPlayerSubsystem : UGameInstanceSubsystem
---@field OnPendingPlayerButtonPressed FPendingPlayerSubsystemOnPendingPlayerButtonPressed
local UPendingPlayerSubsystem = {}

function UPendingPlayerSubsystem:UnregisterSplitscreenButtonFocused() end
function UPendingPlayerSubsystem:UnregisterPendingPlayerButtonPress() end
function UPendingPlayerSubsystem:RegisterSplitscreenButtonFocused() end
function UPendingPlayerSubsystem:RegisterPendingPlayerButtonPress() end
---@param UserIndex int32
---@param PlatformUserId FPlatformUserId
---@param Input FKeyEvent
function UPendingPlayerSubsystem:OnPendingPlayerButtonPressed__DelegateSignature(UserIndex, PlatformUserId, Input) end


---@class UPlayerEffectDataAsset : UDataAsset
---@field bSuppressDirectionalDamageArrows boolean
---@field bShowWhenNoDamage boolean
---@field bAreaOfEffect boolean
---@field DirectionalDamageArrowsDuration float
local UPlayerEffectDataAsset = {}



---@class URetainerBoxLinearColor : URetainerBox
local URetainerBoxLinearColor = {}

---@return UTextureRenderTarget2D
function URetainerBoxLinearColor:GetRenderTarget() end


---@class URosterFriendItemData : UHaloUIViewItemData
---@field DisplayName FText
---@field Nickname FText
---@field PresenceString FText
---@field Status ERosterPresenceStatus
---@field PlatformType ERosterFriendPlatformType
---@field Joinability ERosterJoinability
local URosterFriendItemData = {}

---@param InPresenceString FText
---@param InStatus ERosterPresenceStatus
function URosterFriendItemData:SetPresence(InPresenceString, InStatus) end
---@param InPlatformType ERosterFriendPlatformType
function URosterFriendItemData:SetPlatformType(InPlatformType) end
---@param InNickname FText
function URosterFriendItemData:SetNickname(InNickname) end
---@param InJoinabilityStatus ERosterJoinability
function URosterFriendItemData:SetJoinability(InJoinabilityStatus) end
---@param InDisplayName FText
function URosterFriendItemData:SetDisplayName(InDisplayName) end
---@return FText
function URosterFriendItemData:GetPresenceString() end
---@return ERosterPresenceStatus
function URosterFriendItemData:GetPresenceStatus() end
---@return ERosterFriendPlatformType
function URosterFriendItemData:GetPlatformType() end
---@return FText
function URosterFriendItemData:GetNickname() end
---@return ERosterJoinability
function URosterFriendItemData:GetJoinability() end
---@return FText
function URosterFriendItemData:GetDisplayName() end


---@class USessionBusySubsystem : UGameInstanceSubsystem
local USessionBusySubsystem = {}

---@param Reason FName
function USessionBusySubsystem:ShowInProgressForReason(Reason) end
function USessionBusySubsystem:ShowInProgress() end
---@param Reason FName
function USessionBusySubsystem:HideInProgressForReason(Reason) end
function USessionBusySubsystem:HideInProgress() end


---@class USettingsViewItemDataDropdownControllerPreset : USettingsViewItemDataDropdownString
---@field OriginalChildInstances TArray<UHaloUIViewItemData>
local USettingsViewItemDataDropdownControllerPreset = {}



---@class USettingsViewItemDataDropdownEnum : USettingsViewItemDataDropdownInt
---@field OriginalChildInstances TArray<UHaloUIViewItemData>
local USettingsViewItemDataDropdownEnum = {}



---@class USettingsViewItemDataDropdownInt : UHaloUIViewItemDataDropdown
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataDropdownInt = {}



---@class USettingsViewItemDataDropdownMaximumFrameRate : USettingsViewItemDataDropdownEnum
local USettingsViewItemDataDropdownMaximumFrameRate = {}


---@class USettingsViewItemDataDropdownMonitor : USettingsViewItemDataDropdownString
local USettingsViewItemDataDropdownMonitor = {}


---@class USettingsViewItemDataDropdownNamedValues : UHaloUIViewItemDataDropdown
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataDropdownNamedValues = {}



---@class USettingsViewItemDataDropdownQualityPreset : USettingsViewItemDataDropdownString
local USettingsViewItemDataDropdownQualityPreset = {}


---@class USettingsViewItemDataDropdownString : UHaloUIViewItemDataDropdown
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataDropdownString = {}



---@class USettingsViewItemDataDropdownTag : UHaloUIViewItemDataDropdown
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataDropdownTag = {}



---@class USettingsViewItemDataDropdownUpscaler : USettingsViewItemDataDropdownEnum
local USettingsViewItemDataDropdownUpscaler = {}


---@class USettingsViewItemDataDropdownVoiceChatInputDevice : USettingsViewItemDataDropdownString
---@field VoiceSubsystem TWeakObjectPtr<UMeteoriteVoiceSubsystem>
local USettingsViewItemDataDropdownVoiceChatInputDevice = {}



---@class USettingsViewItemDataDropdownVoiceChatOutputDevice : USettingsViewItemDataDropdownString
---@field VoiceSubsystem TWeakObjectPtr<UMeteoriteVoiceSubsystem>
local USettingsViewItemDataDropdownVoiceChatOutputDevice = {}



---@class USettingsViewItemDataDropdownWindowSize : USettingsViewItemDataDropdownInt
local USettingsViewItemDataDropdownWindowSize = {}


---@class USettingsViewItemDataFloat : UHaloUIViewItemDataFloat
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataFloat = {}



---@class USettingsViewItemDataInteger : UHaloUIViewItemDataInteger
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataInteger = {}



---@class USettingsViewItemDataIntegerFrameGeneration : USettingsViewItemDataInteger
local USettingsViewItemDataIntegerFrameGeneration = {}


---@class USettingsViewItemDataIntegerVSync : USettingsViewItemDataInteger
local USettingsViewItemDataIntegerVSync = {}


---@class USettingsViewItemDataSlider : UHaloUIViewItemDataSlider
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataSlider = {}



---@class USettingsViewItemDataSliderInt : UHaloUIViewItemDataSlider
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataSliderInt = {}



---@class USettingsViewItemDataText : UHaloUIViewItemDataText
---@field ExtensionProperties FSettingsItemDataExtensionProperties
local USettingsViewItemDataText = {}



---@class UShowErrorUI : UBlueprintFunctionLibrary
local UShowErrorUI = {}

---@param AlertName FName
---@return FAlertDataRow
function UShowErrorUI:GetAlertData(AlertName) end
---@param PlayerController APlayerController
---@param Title FText
---@param Message FText
---@return boolean
function UShowErrorUI:AlertPlayerControllerCustomText(PlayerController, Title, Message) end
---@param PlayerController APlayerController
---@param AlertName FName
---@return boolean
function UShowErrorUI:AlertPlayerController(PlayerController, AlertName) end
---@param LocalPlayer ULocalPlayer
---@param Title FText
---@param Message FText
---@return boolean
function UShowErrorUI:AlertLocalPlayerCustomText(LocalPlayer, Title, Message) end
---@param LocalPlayer ULocalPlayer
---@param AlertName FName
---@return boolean
function UShowErrorUI:AlertLocalPlayer(LocalPlayer, AlertName) end
---@param AlertName FName
---@param WorldContextObject UObject
---@return boolean
function UShowErrorUI:AlertDefaultPlayer(AlertName, WorldContextObject) end


---@class UShowInProgressUI : UBlueprintFunctionLibrary
local UShowInProgressUI = {}

---@param InProgressName FName
---@return FInProgressDataRow
function UShowInProgressUI:GetInProgressData(InProgressName) end


---@class UTP_PickUpComponent : USphereComponent
---@field OnPickUp FTP_PickUpComponentOnPickUp
local UTP_PickUpComponent = {}

---@param OverlappedComponent UPrimitiveComponent
---@param OtherActor AActor
---@param OtherComp UPrimitiveComponent
---@param OtherBodyIndex int32
---@param bFromSweep boolean
---@param SweepResult FHitResult
function UTP_PickUpComponent:OnSphereBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult) end


---@class UTP_WeaponComponent : USkeletalMeshComponent
---@field ProjectileClass TSubclassOf<AMeteoriteProjectile>
---@field FireSound USoundBase
---@field FireAnimation UAnimMontage
---@field MuzzleOffset FVector
---@field FireMappingContext UInputMappingContext
---@field FireAction UInputAction
local UTP_WeaponComponent = {}

function UTP_WeaponComponent:Fire() end
---@param EndPlayReason EEndPlayReason::Type
function UTP_WeaponComponent:EndPlay(EndPlayReason) end
---@param TargetCharacter AMeteoriteCharacter
function UTP_WeaponComponent:AttachWeapon(TargetCharacter) end


---@class UTestMenuInputManager : UUserWidget
---@field PlayerIsUsingMouseInput boolean
---@field CurrentSelectedChild int32
---@field OldMousePos FVector2D
local UTestMenuInputManager = {}



---@class UUIItemInfo : UPrimaryDataAsset
---@field ItemName FText
local UUIItemInfo = {}



---@class UWatermarkSettings : UDeveloperSettings
---@field bEnableWatermarkBetaLoose boolean
---@field bEnableWatermarkBetaPackaged boolean
---@field bEnableWatermarkReleaseLoose boolean
---@field bEnableWatermarkReleasePackaged boolean
---@field bEnableWatermarkDefault boolean
local UWatermarkSettings = {}

---@return boolean
function UWatermarkSettings:GetWatermarkEnabled() end



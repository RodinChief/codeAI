#ifndef UE4SS_SDK_BlamEngine_HPP
#define UE4SS_SDK_BlamEngine_HPP

#include "BlamEngine_enums.hpp"

struct FBlamAchievementDefinition
{
    FName AchievementId;                                                              // 0x0000 (size: 0x8)
    bool bRequireIncidentCausePlayer;                                                 // 0x0008 (size: 0x1)
    bool bRequireIncidentEffectPlayer;                                                // 0x0009 (size: 0x1)
    TSoftObjectPtr<UWorld> RequiredUnrealLevel;                                       // 0x0010 (size: 0x28)
    FString RequiredBlamScenarioName;                                                 // 0x0038 (size: 0x10)
    int32 RepeatCount;                                                                // 0x0048 (size: 0x4)
    TArray<FBlamIncidentName> TriggeringIncidents;                                    // 0x0050 (size: 0x10)
    bool bAnyIncidentGeneratesProgress;                                               // 0x0060 (size: 0x1)
    bool bBlockedByDifficultyModifiers;                                               // 0x0061 (size: 0x1)
    bool bBlockedInRemix;                                                             // 0x0062 (size: 0x1)
    FGameplayTagContainer BlockerActiveSkulls;                                        // 0x0068 (size: 0x20)
    FGameplayTagContainer RequiredActiveSkulls;                                       // 0x0088 (size: 0x20)
    FGameplayTagContainer RequiredUnlockedProgresionGamplayTags;                      // 0x00A8 (size: 0x20)

}; // Size: 0xC8

struct FBlamCustomMapping
{
    EBlamInputAction Action;                                                          // 0x0000 (size: 0x1)
    FKey Key;                                                                         // 0x0008 (size: 0x18)
    EBlamKeyBindingSlot BindingSlot;                                                  // 0x0020 (size: 0x1)
    EBlamInputDeviceType InputDevice;                                                 // 0x0021 (size: 0x1)

}; // Size: 0x28

struct FBlamCustomMappingContext
{
    int32 SettingsSaveVersion;                                                        // 0x0000 (size: 0x4)
    FName BasePresetName;                                                             // 0x0004 (size: 0x8)
    TArray<FBlamCustomMapping> CustomMappings;                                        // 0x0010 (size: 0x10)

}; // Size: 0x20

struct FBlamHapticsEventHandle
{
    uint32 InternalId;                                                                // 0x0000 (size: 0x4)

}; // Size: 0x4

struct FBlamIncident
{
    FName Name;                                                                       // 0x0000 (size: 0x8)
    class AActor* CauseObjectActor;                                                   // 0x0008 (size: 0x8)
    int32 CausePlayerAbsoluteIndex;                                                   // 0x0010 (size: 0x4)
    class AActor* EffectObjectActor;                                                  // 0x0018 (size: 0x8)
    int32 EffectPlayerAbsoluteIndex;                                                  // 0x0020 (size: 0x4)
    FBlamDamageReportingInfo DamageReportingInfo;                                     // 0x0024 (size: 0xC)
    FString CustomString;                                                             // 0x0030 (size: 0x10)
    int32 CustomValue;                                                                // 0x0040 (size: 0x4)

}; // Size: 0x48

struct FBlamIncidentNameToMissionCompletionProgress
{
    TMap<class FName, class FBlamMissionsDifficultyProgress> IncidentToProgressMap;   // 0x0000 (size: 0x50)
    TMap<class FName, class FBlamMissionsDifficultyProgress> RemixIncidentToProgressMap; // 0x0050 (size: 0x50)
    TMap<class FName, class FBlamMissionsDifficultyProgress> LASOIncidentToProgressMap; // 0x00A0 (size: 0x50)

}; // Size: 0xF0

struct FBlamIncidentNameToProgressMap
{
    TMap<class FName, class FBlamIncidentProgress> Map;                               // 0x0000 (size: 0x50)

}; // Size: 0x50

struct FBlamIncidentProgress
{
    uint8 bMustBeCausePlayer;                                                         // 0x0000 (size: 0x1)
    uint8 bMustBeEffectPlayer;                                                        // 0x0000 (size: 0x1)
    FGameplayTag ProgressGameplayTag;                                                 // 0x0004 (size: 0x8)

}; // Size: 0xC

struct FBlamInputPreset
{
    FName PresetName;                                                                 // 0x0000 (size: 0x8)
    FName BasePresetName;                                                             // 0x0008 (size: 0x8)
    bool bIsFixed;                                                                    // 0x0010 (size: 0x1)
    class UInputMappingContext* MappingContext;                                       // 0x0018 (size: 0x8)

}; // Size: 0x20

struct FBlamMissionsDifficultyProgress
{
    TMap<class FString, class FGameplayTag> ScenarioNameToGameplayTagMap;             // 0x0000 (size: 0x50)

}; // Size: 0x50

struct FBlamPlayerEffect
{
    int32 LocalPlayerIndex;                                                           // 0x0000 (size: 0x4)
    FBlamDamageOwner DamageOwner;                                                     // 0x0008 (size: 0x8)
    FVector Origin;                                                                   // 0x0010 (size: 0x18)
    float DamageScale;                                                                // 0x0028 (size: 0x4)
    float NormalizedBodyDamage;                                                       // 0x002C (size: 0x4)
    float NormalizedShieldDamage;                                                     // 0x0030 (size: 0x4)
    float NormalizedTotalDamage;                                                      // 0x0034 (size: 0x4)
    FBlamPlayerEffectFlags Flags;                                                     // 0x0038 (size: 0x4)
    class UObject* DataAsset;                                                         // 0x0040 (size: 0x8)

}; // Size: 0x48

struct FBlamRenderSettingsChangeData
{
}; // Size: 0x10

struct FBlamSavedActorComponentRecord
{
    TSoftClassPtr<UActorComponent> Class;                                             // 0x0000 (size: 0x28)
    bool bIsDefaultComponent;                                                         // 0x0038 (size: 0x1)
    FString ComponentName;                                                            // 0x0040 (size: 0x10)

}; // Size: 0x50

struct FBlamSavedActorRecord
{
    TSoftClassPtr<AActor> Class;                                                      // 0x0000 (size: 0x28)
    int16 BlamObjectGameStateIdentifier;                                              // 0x0038 (size: 0x2)
    TArray<FBlamSavedActorComponentRecord> Components;                                // 0x0040 (size: 0x10)
    FString Name;                                                                     // 0x0050 (size: 0x10)

}; // Size: 0x60

struct FBlamScenarioDataTableRow : public FTableRowBase
{
    TSoftObjectPtr<UWorld> UnrealLevel;                                               // 0x0008 (size: 0x28)
    FString ScenarioName;                                                             // 0x0030 (size: 0x10)
    FGuid MapGuid;                                                                    // 0x0040 (size: 0x10)
    FText MissionTitle;                                                               // 0x0050 (size: 0x10)
    FText MissionDescription;                                                         // 0x0060 (size: 0x10)
    TSoftObjectPtr<UTexture2D> MissionPreviewImage;                                   // 0x0070 (size: 0x28)
    class UScenarioInsertionPointAsset* InsertionPointsDataAsset;                     // 0x0098 (size: 0x8)
    FGameplayTag ProgressionUnlockTag;                                                // 0x00A0 (size: 0x8)

}; // Size: 0xA8

struct FBlamScenarioGameOptions
{
    bool bLoadFromCoreSave;                                                           // 0x0001 (size: 0x1)
    uint8 SaveSlot;                                                                   // 0x0002 (size: 0x1)
    FString SavedFilmName;                                                            // 0x0008 (size: 0x10)
    EBlamCampaignDifficultyLevel CampaignDifficultyLevel;                             // 0x0018 (size: 0x1)
    int32 InsertionPoint;                                                             // 0x001C (size: 0x4)
    TSet<EBlamGameSkulls> ActiveSkulls;                                               // 0x0020 (size: 0x50)
    bool bFriendlyFireEnabled;                                                        // 0x0070 (size: 0x1)
    bool bIsLASO;                                                                     // 0x0071 (size: 0x1)
    class UBlamGameEngineBaseVariant* GameVariant;                                    // 0x0078 (size: 0x8)

}; // Size: 0x88

struct FBlamScenarioPlayerAppearanceCustomization
{
    FString VariantName;                                                              // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FBlamUnrealSavedState
{
    TArray<FBlamSavedActorRecord> SavedActors;                                        // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FCameraFollowSettings
{
    TSoftObjectPtr<AActor> ActorToFollow;                                             // 0x0000 (size: 0x28)
    FVector RelativeOffset;                                                           // 0x0028 (size: 0x18)
    bool bFollowEnabled;                                                              // 0x0040 (size: 0x1)

}; // Size: 0x48

struct FCampaignMetagameScenario
{
    float ParScore;                                                                   // 0x0000 (size: 0x4)
    TArray<FCampaignMetagameScenarioCompletionBonus> TimeBonuses;                     // 0x0008 (size: 0x10)

}; // Size: 0x18

struct FCampaignMetagameScenarioCompletionBonus
{
    float Time;                                                                       // 0x0000 (size: 0x4)
    float ScoreMultiplier;                                                            // 0x0004 (size: 0x4)

}; // Size: 0x8

struct FColorSlotData
{
    FColor ActiveColor;                                                               // 0x0000 (size: 0x4)
    float TransitionTime;                                                             // 0x0004 (size: 0x4)
    class UCurveFloat* TransitionCurve;                                               // 0x0008 (size: 0x8)
    float SlotDuration;                                                               // 0x0010 (size: 0x4)

}; // Size: 0x18

struct FDataLayerSelector
{
    TSet<TSoftObjectPtr<UDataLayerAsset>> DataLayerAssets;                            // 0x0000 (size: 0x50)

}; // Size: 0x50

struct FEquipmentSpawnInfluence
{
    TSoftObjectPtr<UBlamEquipmentTagDataAsset> Equipment;                             // 0x0000 (size: 0x28)
    float Weight;                                                                     // 0x0028 (size: 0x4)

}; // Size: 0x30

struct FGameGlobalsPlayerRepresentation
{
    FPlayerRepresentationFlags Flags;                                                 // 0x0000 (size: 0x4)
    TSoftObjectPtr<UBlamChudDefinitionTagDataAsset> ChudReference;                    // 0x0008 (size: 0x28)
    TSoftObjectPtr<UBlamRenderModelTagDataAsset> FirstPersonHands;                    // 0x0030 (size: 0x28)
    TSoftObjectPtr<UBlamRenderModelTagDataAsset> FirstPersonBody;                     // 0x0058 (size: 0x28)
    TSoftObjectPtr<UBlamUnitTagDataAsset> ThirdPersonUnit;                            // 0x0080 (size: 0x28)
    FString ThirdPersonVariant;                                                       // 0x00A8 (size: 0x10)
    TSoftObjectPtr<UBlamEquipmentTagDataAsset> IntrinsicEquipment;                    // 0x00B8 (size: 0x28)
    TSoftObjectPtr<UBlamBaseSoundTagDataAsset> BinocularsZoomInSound;                 // 0x00E0 (size: 0x28)
    TSoftObjectPtr<UBlamBaseSoundTagDataAsset> BinocularsZoomOutSounds;               // 0x0108 (size: 0x28)

}; // Size: 0x130

struct FGamepadLightEventData
{
    FName EventId;                                                                    // 0x0000 (size: 0x8)
    EGamepadLightEventType EventType;                                                 // 0x0008 (size: 0x1)
    TArray<FColorSlotData> ColorSequence;                                             // 0x0010 (size: 0x10)
    int32 Priority;                                                                   // 0x0020 (size: 0x4)
    bool bStopTrigger;                                                                // 0x0024 (size: 0x1)
    FName EventToStop;                                                                // 0x0028 (size: 0x8)

}; // Size: 0x30

struct FHaloMaterialResponseData
{
    FGameplayTag ResponseTag;                                                         // 0x0000 (size: 0x8)
    FVector Forward;                                                                  // 0x0008 (size: 0x18)
    FVector ImpactPoint;                                                              // 0x0020 (size: 0x18)
    FVector ImpactNormal;                                                             // 0x0038 (size: 0x18)
    TWeakObjectPtr<class AActor> ImpactingObject;                                     // 0x0050 (size: 0x8)
    TWeakObjectPtr<class AActor> ImpactedObject;                                      // 0x0058 (size: 0x8)
    TWeakObjectPtr<class UPhysicalMaterial> PhysMaterial;                             // 0x0060 (size: 0x8)
    FName ImpactedBoneName;                                                           // 0x0068 (size: 0x8)
    FName ImpactingBoneName;                                                          // 0x0070 (size: 0x8)
    TWeakObjectPtr<class UBlamTagDataAssetBase> ImpactingTag;                         // 0x0078 (size: 0x8)
    TWeakObjectPtr<class UBlamTagDataAssetBase> ImpactedTag;                          // 0x0080 (size: 0x8)
    FGameplayTag SurfaceGameplayTag;                                                  // 0x0088 (size: 0x8)

}; // Size: 0x90

struct FHaloPhysicalMaterialToGameplayTagRow : public FTableRowBase
{
    TSoftObjectPtr<UPhysicalMaterial> Material;                                       // 0x0008 (size: 0x28)
    FGameplayTag Tag;                                                                 // 0x0030 (size: 0x8)

}; // Size: 0x38

struct FInputMapperOutputErrorData
{
    EBlamInputAction ExclusivityErrorAction;                                          // 0x0000 (size: 0x1)
    EBlamKeyBindingSlot ExclusivityErrorSlot;                                         // 0x0001 (size: 0x1)

}; // Size: 0x2

struct FPlayerRepresentationFlags
{
    uint8 bCanUseHealthPacks;                                                         // 0x0000 (size: 0x1)

}; // Size: 0x4

struct FProjectileSpawnInfluence
{
    TSoftObjectPtr<UBlamProjectileTagDataAsset> Projectile;                           // 0x0000 (size: 0x28)
    float LeadTime;                                                                   // 0x0028 (size: 0x4)
    float CollisionCylinderRadius;                                                    // 0x002C (size: 0x4)
    float Weight;                                                                     // 0x0030 (size: 0x4)

}; // Size: 0x38

struct FScenarioCinematicReference
{
    FScenarioCinematicsFlags Flags;                                                   // 0x0000 (size: 0x4)
    TSoftObjectPtr<UBlamCinematicTagDataAsset> Cinematic;                             // 0x0008 (size: 0x28)

}; // Size: 0x30

struct FScenarioCinematicsFlags
{
    uint8 bDebugOnly;                                                                 // 0x0000 (size: 0x1)

}; // Size: 0x4

struct FScenarioCutsceneTitle
{
    FString Name;                                                                     // 0x0000 (size: 0x10)
    FString DelayedName2;                                                             // 0x0010 (size: 0x10)
    FString DelayedName3;                                                             // 0x0020 (size: 0x10)
    EScenarioCutsceneTitleTransitionType TransitionType;                              // 0x0030 (size: 0x4)

}; // Size: 0x38

struct FScenarioFlags
{
    uint8 bDontStripPathfinding;                                                      // 0x0000 (size: 0x1)
    uint8 bQuickLoadingCinematicOnlyScenario;                                         // 0x0000 (size: 0x1)
    uint8 bCharactersUsePreviousMissionWeapons;                                       // 0x0000 (size: 0x1)
    uint8 bSnapToWhiteAtStart;                                                        // 0x0000 (size: 0x1)
    uint8 bBigVehicleUseCenterPointForLightSampling;                                  // 0x0000 (size: 0x1)
    uint8 bDontUseCampaignSharing;                                                    // 0x0000 (size: 0x1)
    uint8 bIgnoreSizeAndCanTShip;                                                     // 0x0000 (size: 0x1)
    uint8 bInSpace;                                                                   // 0x0000 (size: 0x1)
    uint8 bSurvival;                                                                  // 0x0001 (size: 0x1)
    uint8 bDoNotStripVariants;                                                        // 0x0001 (size: 0x1)

}; // Size: 0x4

struct FScenarioInsertionPoint
{
    FString Name;                                                                     // 0x0000 (size: 0x10)
    FString ZoneSetString;                                                            // 0x0010 (size: 0x10)
    FGuid Guid;                                                                       // 0x0020 (size: 0x10)
    FText Title;                                                                      // 0x0030 (size: 0x10)
    FText Description;                                                                // 0x0040 (size: 0x10)
    TSoftObjectPtr<UTexture2D> PreviewImage;                                          // 0x0050 (size: 0x28)
    FGameplayTag ProgressionUnlockTag;                                                // 0x0078 (size: 0x8)
    bool bRemoveFromShippingBuilds;                                                   // 0x0080 (size: 0x1)

}; // Size: 0x88

struct FScenarioSoftCeiling
{
    FString Name;                                                                     // 0x0000 (size: 0x10)
    FScenarioSoftCeilingFlagsDefinition Flags;                                        // 0x0010 (size: 0x4)
    ESoftCeilingTypeEnum Type;                                                        // 0x0014 (size: 0x4)

}; // Size: 0x18

struct FScenarioSoftCeilingFlagsDefinition
{
    uint8 bIgnoreBipeds;                                                              // 0x0000 (size: 0x1)
    uint8 bIgnoreVehicles;                                                            // 0x0000 (size: 0x1)
    uint8 bIgnoreCamera;                                                              // 0x0000 (size: 0x1)
    uint8 bIgnoreHugeVehicles;                                                        // 0x0000 (size: 0x1)

}; // Size: 0x4

struct FScenarioStructureBspReference
{
    FString StructureBsp;                                                             // 0x0000 (size: 0x10)
    FString StructureLightingInfo;                                                    // 0x0010 (size: 0x10)
    FScenarioStructureBspReferenceFlagsDefinition Flags;                              // 0x0020 (size: 0x4)
    float CustomGravityScale;                                                         // 0x0024 (size: 0x4)

}; // Size: 0x28

struct FScenarioStructureBspReferenceFlagsDefinition
{
    uint8 bNoPathfinding;                                                             // 0x0000 (size: 0x1)
    uint8 bNotANormallyPlayableSpaceInAnMPMapCheckThisOnSharedBSPs;                   // 0x0000 (size: 0x1)
    uint8 bCustomGravityScale;                                                        // 0x0000 (size: 0x1)
    uint8 bNoDefaultStructurePathfinding;                                             // 0x0000 (size: 0x1)

}; // Size: 0x4

struct FScenarioStructureDesignReference
{
    FString StructureDesign;                                                          // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FScenarioUserInterfaceObjective
{
    FString Name;                                                                     // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FScenarioZoneSet
{
    FString Name;                                                                     // 0x0000 (size: 0x10)
    FString NameString;                                                               // 0x0010 (size: 0x10)
    FScenarioZoneSetFlagsDefinition Flags;                                            // 0x0020 (size: 0x4)
    FString BspZoneFlags;                                                             // 0x0028 (size: 0x10)
    FString StructureDesignZoneFlags;                                                 // 0x0038 (size: 0x10)

}; // Size: 0x48

struct FScenarioZoneSetFlagsDefinition
{
    uint8 bBeginLoadingNextLevel;                                                     // 0x0000 (size: 0x1)
    uint8 bDebugPurposesOnly;                                                         // 0x0000 (size: 0x1)

}; // Size: 0x4

struct FVehicleSpawnInfluence
{
    TSoftObjectPtr<UBlamVehicleTagDataAsset> Vehicle;                                 // 0x0000 (size: 0x28)
    float PillRadius;                                                                 // 0x0028 (size: 0x4)
    float LeadTime;                                                                   // 0x002C (size: 0x4)
    float MinimumVelocity;                                                            // 0x0030 (size: 0x4)
    float Weight;                                                                     // 0x0034 (size: 0x4)

}; // Size: 0x38

struct FWeaponSpawnInfluence
{
    TSoftObjectPtr<UBlamWeaponTagDataAsset> Weapon;                                   // 0x0000 (size: 0x28)
    float FullWeightRange;                                                            // 0x0028 (size: 0x4)
    float FallOffRange;                                                               // 0x002C (size: 0x4)
    float FallOffConeRadius;                                                          // 0x0030 (size: 0x4)
    float Weight;                                                                     // 0x0034 (size: 0x4)

}; // Size: 0x38

class ABlamCinematicCamera : public ACineCameraActor
{
    FCameraFollowSettings FollowSettings;                                             // 0x0AA8 (size: 0x48)

}; // Size: 0xAF0

class ABlamDebugRenderActor : public AActor
{
    class UBlamDebugMeshComponent* LineListComponent;                                 // 0x02E0 (size: 0x8)
    class UBlamDebugMeshComponent* TriangleListComponent;                             // 0x02E8 (size: 0x8)
    class UFont* DefaultFont;                                                         // 0x02F0 (size: 0x8)

}; // Size: 0x308

class ABlamGameMode : public AHaloModularGameModeBase
{
    TWeakObjectPtr<class AActor> InsertionPointStartSpot;                             // 0x038C (size: 0x8)

    void OnGameModePlayerInitialized__DelegateSignature(class AGameModeBase* GAMEMODE, class AController* NewController);
}; // Size: 0x3A8

class ABlamGameModePlayerStart : public ANavigationObjectBase
{
    FString InsertionPointName;                                                       // 0x0300 (size: 0x10)

}; // Size: 0x310

class ABlamGameState : public AHaloModularGameStateBase
{
    TSubclassOf<class UActorComponent> IncidentHandlerComponentClass;                 // 0x0330 (size: 0x8)
    class UActorComponent* IncidentHandlerComponent;                                  // 0x0338 (size: 0x8)
    class UBlamCampaignFlowGameStateComponent* BlamCampaignFlowComponent;             // 0x0340 (size: 0x8)
    class UBlamNetworkGameStateComponent* BlamNetworkGameStateComponent;              // 0x0348 (size: 0x8)
    class UBlamSkullsGameStateComponent* BlamSkullsGameStateComponent;                // 0x0350 (size: 0x8)
    class UBlamExperienceManagerComponent* ExperienceManagerComponent;                // 0x0358 (size: 0x8)

}; // Size: 0x360

class ABlamHUD : public AHUD
{
}; // Size: 0x3C8

class ABlamPawn : public AHaloModularPawn
{
    FBlamPawnOnFirstPersonStateChanged OnFirstPersonStateChanged;                     // 0x0358 (size: 0x10)
    void OnStateChanged(EBlamFirstPersonWeaponState PreviousState, FName PreviousAnimationName, EBlamFirstPersonWeaponState NewState, FName NewAnimationName);
    FBlamPawnOnFirstPersonOverlayChanged OnFirstPersonOverlayChanged;                 // 0x0368 (size: 0x10)
    void OnOverlayChanged(EBlamFirstPersonWeaponOverlay PreviousOverlay, FName PreviousAnimationName, EBlamFirstPersonWeaponOverlay NewOverlay, FName NewAnimationName);
    FBlamPawnOnUnitChanged OnUnitChanged;                                             // 0x0378 (size: 0x10)
    void OnUnitChanged(class AActor* PreviousUnitActor, class AActor* UnitActor);
    FBlamPawnOnMovingChanged OnMovingChanged;                                         // 0x0388 (size: 0x10)
    void OnMovingChanged();
    FBlamPawnOnCameraPerspectiveChanged OnCameraPerspectiveChanged;                   // 0x0398 (size: 0x10)
    void OnCameraPerspectiveChanged();
    EBlamFirstPersonWeaponState FirstPersonState;                                     // 0x03A8 (size: 0x1)
    FName FirstPersonStateAnimationName;                                              // 0x03AC (size: 0x8)
    EBlamFirstPersonWeaponOverlay FirstPersonOverlay;                                 // 0x03B4 (size: 0x1)
    FName FirstPersonOverlayAnimationName;                                            // 0x03B8 (size: 0x8)
    bool bPlayerIsMoving;                                                             // 0x03C0 (size: 0x1)
    EBlamCameraPerspective CurrentBlamCameraPerspective;                              // 0x03C1 (size: 0x1)
    float PlayerCrouchLevel;                                                          // 0x03C4 (size: 0x4)
    class UCameraComponent* CameraComponent;                                          // 0x03C8 (size: 0x8)
    class USceneComponent* DefaultSceneComponent;                                     // 0x03D0 (size: 0x8)
    class UBlamMeshSynchronizationComponent* ArmsMeshSynchronizationComponent;        // 0x03D8 (size: 0x8)
    class UBlamMeshSynchronizationComponent* LegsMeshSynchronizationComponent;        // 0x03E0 (size: 0x8)
    class UBlamSkeletonSynchronizationComponent* SkeletonSynchronizationComponent;    // 0x03E8 (size: 0x8)
    FName FirstPersonWeaponSocketAttachmentName;                                      // 0x03F0 (size: 0x8)

    void OnUnitChanged__DelegateSignature(class AActor* PreviousUnitActor, class AActor* UnitActor);
    void OnStateChanged__DelegateSignature(EBlamFirstPersonWeaponState PreviousState, FName PreviousAnimationName, EBlamFirstPersonWeaponState NewState, FName NewAnimationName);
    void OnOverlayChanged__DelegateSignature(EBlamFirstPersonWeaponOverlay PreviousOverlay, FName PreviousAnimationName, EBlamFirstPersonWeaponOverlay NewOverlay, FName NewAnimationName);
    void OnMovingChanged__DelegateSignature();
    void OnCameraPerspectiveChanged__DelegateSignature();
    void GetPawnViewModeAndWeaponActors(EBlamCameraPerspective& OutViewMode, class AActor*& ThirdPersonWeapon, class AActor*& FirstPersonWeapon);
    UClass* GetEquippedWeaponClass();
    class AActor* GetBlamObjectActor();
}; // Size: 0x438

class ABlamPlayerController : public AHaloModularPlayerController
{

    void OnUnitChanged(class AActor* PreviousPlayerActor, class AActor* NewPlayerActor);
    void ClientSetPendingSessionLeaveReason(ESessionLeaveReason Reason);
}; // Size: 0x970

class ABlamPlayerState : public AHaloModularPlayerState
{
    class UBlamExperiencePlayerStateComponent* BlamExperiencePlayerStateComponent;    // 0x0390 (size: 0x8)
    class UBlamNetworkPlayerStateComponent* BlamNetworkPlayerStateComponent;          // 0x0398 (size: 0x8)
    class UBlamPlayerStateComponent* BlamPlayerStateComponent;                        // 0x03A0 (size: 0x8)
    class UHaloPrivilegePlayerStateComponent* HaloPrivilegePlayerStateComponent;      // 0x03A8 (size: 0x8)

}; // Size: 0x3B0

class ABlamScenario : public AActor
{
    FString ScenarioName;                                                             // 0x02D8 (size: 0x10)
    FDataLayerSelector ScenarioDataLayers;                                            // 0x02E8 (size: 0x50)
    TArray<FFilePath> ScenarioScripts;                                                // 0x0338 (size: 0x10)
    bool bIncludeActorsNotInLayers;                                                   // 0x0348 (size: 0x1)
    EScenarioTypeEnum Type;                                                           // 0x034C (size: 0x4)
    FScenarioFlags Flags;                                                             // 0x0350 (size: 0x4)
    int32 CampaignId;                                                                 // 0x0354 (size: 0x4)
    int32 MapId;                                                                      // 0x0358 (size: 0x4)
    FString MAPNAME;                                                                  // 0x0360 (size: 0x10)
    int16 SoundPermutationMissionId;                                                  // 0x0370 (size: 0x2)
    float LocalNorth;                                                                 // 0x0374 (size: 0x4)
    float LocalSeaLevel;                                                              // 0x0378 (size: 0x4)
    float AltitudeCap;                                                                // 0x037C (size: 0x4)
    FVector3f SandboxOriginPoint;                                                     // 0x0380 (size: 0xC)
    float SandboxBudget;                                                              // 0x038C (size: 0x4)
    FString DefaultVehicleSet;                                                        // 0x0390 (size: 0x10)
    FBlamScenarioPlayerAppearanceCustomization PlayerAppearanceCustomizations;        // 0x03A0 (size: 0x40)
    TSoftObjectPtr<UBlamGamePerformanceThrottleTagDataAsset> GamePerformanceThrottles; // 0x03E0 (size: 0x28)
    TSoftObjectPtr<UBlamMultiplayerObjectTypeListTagDataAsset> MultiplayerObjectTypes; // 0x0408 (size: 0x28)
    TSoftObjectPtr<UBlamAirstrikeTagDataAsset> AirStrike;                             // 0x0430 (size: 0x28)
    TArray<TSoftObjectPtr<UBlamStyleTagDataAsset>> AiStyle;                           // 0x0458 (size: 0x10)
    TSoftObjectPtr<UBlamAiMissionDialogueTagDataAsset> MissionDialogue;               // 0x0468 (size: 0x28)
    TArray<FScenarioCutsceneTitle> CutsceneChapterTitles;                             // 0x0490 (size: 0x10)
    TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset> ChapterTitleText;  // 0x04A0 (size: 0x28)
    TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset> Subtitles;         // 0x04C8 (size: 0x28)
    TSoftObjectPtr<UBlamMultilingualUnicodeStringListTagDataAsset> Objectives;        // 0x04F0 (size: 0x28)
    class UScenarioUserInterfaceObjectiveAsset* UserInterfaceObjectivesDataAsset;     // 0x0518 (size: 0x8)
    TSoftObjectPtr<UBlamScenarioInterpolatorTagDataAsset> Interpolators;              // 0x0520 (size: 0x28)
    TSoftObjectPtr<UBlamPerformanceThrottlesTagDataAsset> PerformanceThrottles;       // 0x0548 (size: 0x28)
    TArray<FGameGlobalsPlayerRepresentation> OverridePlayerRepresentations;           // 0x0570 (size: 0x10)
    TSoftObjectPtr<UBlamLocationNameGlobalsDefinitionTagDataAsset> LocationNameGlobals; // 0x0580 (size: 0x28)
    TSoftObjectPtr<UBlamChudDefinitionTagDataAsset> ChudReference;                    // 0x05A8 (size: 0x28)
    TSoftObjectPtr<UBlamScenarioRequiredResourceTagDataAsset> RequiredResources;      // 0x05D0 (size: 0x28)
    FCampaignMetagameScenario CampaignMetagame;                                       // 0x05F8 (size: 0x18)
    TArray<FScenarioSoftCeiling> SoftCeilings;                                        // 0x0610 (size: 0x10)
    class UScenarioInsertionPointAsset* InsertionPointsDataAsset;                     // 0x0620 (size: 0x8)
    TArray<FScenarioInsertionPoint> InsertionPoints;                                  // 0x0628 (size: 0x10)
    TArray<FWeaponSpawnInfluence> WeaponSpawnInfluencers;                             // 0x0638 (size: 0x10)
    TArray<FVehicleSpawnInfluence> VehicleSpawnInfluencers;                           // 0x0648 (size: 0x10)
    TArray<FProjectileSpawnInfluence> ProjectileSpawnInfluencers;                     // 0x0658 (size: 0x10)
    TArray<FEquipmentSpawnInfluence> EquipmentSpawnInfluencers;                       // 0x0668 (size: 0x10)
    FString StructureSeams;                                                           // 0x0678 (size: 0x10)
    TArray<FScenarioStructureBspReference> StructureBsps;                             // 0x0688 (size: 0x10)
    TArray<FScenarioStructureDesignReference> StructureDesigns;                       // 0x0698 (size: 0x10)
    TArray<FScenarioZoneSet> ZoneSets;                                                // 0x06A8 (size: 0x10)
    TArray<FScenarioCinematicReference> Cinematics;                                   // 0x06B8 (size: 0x10)
    TSoftObjectPtr<UBlamEncounterRemixTagDataAsset> EncounterRemix;                   // 0x06C8 (size: 0x28)

}; // Size: 0x6F0

class ABlamWorldSettings : public AWorldSettings
{
    TSoftObjectPtr<ABlamScenario> DefaultScenario;                                    // 0x0500 (size: 0x28)
    TSoftClassPtr<UBlamExperienceDefinition> DefaultBlamExperience;                   // 0x0528 (size: 0x28)

    int32 DestroyComponents(const TArray<class UActorComponent*>& Components, bool bDetachSceneComponentsFirst);
}; // Size: 0x550

class AFrontendGameMode : public AHaloModularGameModeBase
{
}; // Size: 0x3C0

class IBlamGameUserSettingsValidation : public IInterface
{

    bool ValidateCustomization(const TArray<FGameplayTag>& CustomizationNames);
}; // Size: 0x28

class IBlamSaveGameEventInterface : public IInterface
{

    void PreActorSerialize();
    void OnStateRestoredFromSaveGame();
    void OnBlamMapResetEvent();
}; // Size: 0x28

class IBlamScenarioActor : public IInterface
{
}; // Size: 0x28

class UBlamAchievementListDataAsset : public UDataAsset
{
    TArray<FBlamAchievementDefinition> Achievements;                                  // 0x0030 (size: 0x10)

}; // Size: 0x40

class UBlamAchievementLocalPlayerSubsystem : public UBlamIncidentHandlerLocalPlayerSubsystem
{
}; // Size: 0x120

class UBlamAcousticPortalBreakableSurfaceComponent : public UHaloAudioPortalDoorComponent
{
    FGuid BreakableSurfaceTemplateGuid;                                               // 0x00F0 (size: 0x10)
    double MaxProximity;                                                              // 0x0100 (size: 0x8)

}; // Size: 0x108

class UBlamAcousticPortalComponent : public UHaloAudioPortalDoorComponent
{
    int32 ScenarioObjectIdentifier;                                                   // 0x00F0 (size: 0x4)
    bool bInvertedOpenDirection;                                                      // 0x00F4 (size: 0x1)

    void OnDevicePositionFractionChanged(float PreviousPositionFraction, float PositionFraction, EBlamPropertyChangeReason BlamPropertyChangeReason);
}; // Size: 0x100

class UBlamBreakableSurfaceSaveGame : public UBlamSaveGame
{
}; // Size: 0x30

class UBlamBreakableSurfaceSaveGameSubsystem : public UWorldSubsystem
{
}; // Size: 0x48

class UBlamBuiltInMapInfoDataAsset : public UPrimaryDataAsset
{
    TArray<class UBlamCampaignDataAsset*> CampaignInfos;                              // 0x0030 (size: 0x10)
    TArray<class UDataTable*> CampaignMapInfoTables;                                  // 0x0040 (size: 0x10)

}; // Size: 0x50

class UBlamCampaignDataAsset : public UDataAsset
{
    FGuid CampaignGuid;                                                               // 0x0030 (size: 0x10)
    TArray<FDataTableRowHandle> ScenarioList;                                         // 0x0040 (size: 0x10)
    EBlamCampaignType CampaignType;                                                   // 0x0050 (size: 0x1)

}; // Size: 0x58

class UBlamCampaignFlowGameStateComponent : public UGameStateComponent
{
    class UBlamCampaignDataAsset* ActiveCampaign;                                     // 0x00C0 (size: 0x8)
    bool bIsInLASO;                                                                   // 0x00C8 (size: 0x1)

    void OnRep_ActiveCampaign();
}; // Size: 0xD0

class UBlamCampaignFlowGameSubsystem : public UGameInstanceSubsystem
{
    class UBlamCampaignDataAsset* CurrentCampaign;                                    // 0x0030 (size: 0x8)

    bool SetAndBeginCampaign(const class UBlamCampaignDataAsset* Campaign, const FName StartingScenarioName, const FBlamScenarioGameOptions& Options);
    void SetActiveCampaign(const class UBlamCampaignDataAsset* Campaign);
    void RevertToLastSave();
    void RestartLevel();
    void LeaveGame();
    FName GetLastBlamErrorName();
    void EndCampaign();
    bool BeginCampaign(const FName StartingScenarioName, const FBlamScenarioGameOptions& Options);
    void AcknowledgeLastBlamError();
}; // Size: 0xB8

class UBlamCinematicSubsystem : public UBlamGameInstanceSubsystem
{
    FBlamCinematicSubsystemOnCinematicInProgress OnCinematicInProgress;               // 0x0078 (size: 0x10)
    void OnCinematicInProgress(bool bInProgress);
    FBlamCinematicSubsystemOnCinematicBegin OnCinematicBegin;                         // 0x0088 (size: 0x10)
    void OnCinematicBegin(class ULevelSequence* LevelSequence);
    FBlamCinematicSubsystemOnCinematicEnd OnCinematicEnd;                             // 0x0098 (size: 0x10)
    void OnCinematicEnd(bool bWasSkipped);
    class ALevelSequenceActor* LevelSequenceActor;                                    // 0x00A8 (size: 0x8)

    void OnSubtitleShown(FHaloUIShowSubtitle ShowSubtitleData);
    void OnCinematicInProgress__DelegateSignature(bool bInProgress);
    void OnCinematicEnd__DelegateSignature(bool bWasSkipped);
    void OnCinematicBegin__DelegateSignature(class ULevelSequence* LevelSequence);
    bool IsCinematicInProgress();
}; // Size: 0xE8

class UBlamControllerHapticsSubsystem : public UBlamGameInstanceSubsystem
{

    FBlamHapticsEventHandle TriggerHapticsEvent(const class UBlamHapticsEventBase* Event, const FBlamControllerHapticsEventParams& Params);
    bool StopHapticsEvent(FBlamHapticsEventHandle HapticsEventHandle);
    FBlamHapticsEventHandle SetWeaponTriggerResistance(const class UBlamHapticsEventTriggerBase* Event, const FBlamControllerHapticsEventParams& Params);
    bool ResetWeaponTriggerResistance(FBlamHapticsEventHandle HapticsEventHandle);
}; // Size: 0xC8

class UBlamCookedTagReferencesEngineSubsystem : public UEngineSubsystem
{
}; // Size: 0x90

class UBlamDataSaveGame : public UBlamSaveGame
{
}; // Size: 0x40

class UBlamDebugMenuWidget : public UUserWidget
{
    class UBlamGameStateObjectDebugMenuWidget* GameStateObjectDebugMenuWidget;        // 0x02D0 (size: 0x8)

    void SetShowTagDebugNames(bool bShow, TArray<bool> EnabledTypes);
}; // Size: 0x2D8

class UBlamDebugMeshComponent : public UDebugDrawComponent
{
}; // Size: 0x550

class UBlamDecalManagerSaveGame : public UBlamSaveGame
{
}; // Size: 0x40

class UBlamDecalManagerSubsystem : public UWorldSubsystem
{
    class AActor* DecalOwner;                                                         // 0x0048 (size: 0x8)
    TMap<int32, UDecalComponent*> TrackedDecals;                                      // 0x0050 (size: 0x50)

    int32 SpawnTrackedDecalDelayed(class UMaterialInterface* DecalMaterial, const FTransform& DecalTransform, const FVector& DecalSize, const float SpawnDelayTime);
    int32 SpawnTrackedDecal(class UMaterialInterface* DecalMaterial, const FTransform& DecalTransform, const FVector& DecalSize);
    bool DestroyTrackedDecal(int32 DecalIndentifier);
}; // Size: 0xB0

class UBlamDeferredEventHandlerSubsystem : public UEngineSubsystem
{
}; // Size: 0x80

class UBlamDeveloperSettings : public UDeveloperSettings
{
    TSoftObjectPtr<UBlamPlayerModelCustomizationGlobalsTagDataAsset> CustomizationGlobalsTag; // 0x0038 (size: 0x28)
    TSoftObjectPtr<UBlamProgressDataAsset> ProgressDataAsset;                         // 0x0060 (size: 0x28)
    TSoftObjectPtr<UBlamAchievementListDataAsset> AchievementListDataAsset;           // 0x0088 (size: 0x28)
    TArray<FName> InitialInstalledScenarioNames;                                      // 0x00B0 (size: 0x10)

    bool LevelIsReadyToAttemptLoading(const FName StartingScenarioName);
}; // Size: 0xC0

class UBlamEngineAssetManager : public UHaloAssetManager
{
    TSoftObjectPtr<UBlamBuiltInMapInfoDataAsset> BuiltInMapInfoDataPath;              // 0x05B0 (size: 0x28)

}; // Size: 0x5D8

class UBlamEngineAudioGameSubsystem : public UBlamGameInstanceSubsystem
{
    int32 PostLoadingScreenDelayFrames;                                               // 0x0080 (size: 0x4)
    int32 PostPauseMenuDelayFrames;                                                   // 0x0084 (size: 0x4)

    class UWorld* TryGetWorld();
    FSoftObjectPath TryGetPlayingCinematic();
    class ABlamGameState* TryGetBlamGameState();
    void SetGlobalState(const class UAkStateValue* AkStateValue);
    void SetGlobalRtpc(const class UAkRtpc* AkRtpc, float RtpcValue);
    void SendMusicEvent(const class UHaloAudioMusicControl* MusicControl);
    void SendGlobalEvent(const class UAkAudioEvent* AkEvent);
    void OnStateChanged(EBlamEngineAudioState OldState, EBlamEngineAudioState NewState);
    void OnSkullsRemoved(const FGameplayTagContainer& SkullsAdded);
    void OnSkullsAdded(const FGameplayTagContainer& SkullsAdded);
    void OnReturnToMainMenuTriggered();
    void OnLoadLoadingManagerLoadFinishedOrFailed();
    void OnLoadingManagerLoadStarted();
    void OnInitialize();
    void OnDeinitialize();
    void OnCinematicSubsystemEndCinematic(bool bWasSkipped);
    void OnCinematicSubsystemBeginCinematic(class ULevelSequence* LevelSequence);
    void OnCinematicEnd(const FSoftObjectPath& Cinematic, bool bWasSkipped);
    void OnCinematicBegin(const FSoftObjectPath& Cinematic);
    bool IsNetworkCoop();
    EBlamEngineAudioState GetState();
    bool GetIsPaused();
    FGameplayTagContainer GetActiveSkulls();
}; // Size: 0xC0

class UBlamEngineAudioSaveGame : public UBlamSaveGame
{
}; // Size: 0x108

class UBlamEngineGlueOuterSubsystemImpl : public UBlamEngineGlueOuterSubsystem
{
}; // Size: 0x108

class UBlamEngineHelperLibrary : public UBlueprintFunctionLibrary
{

    bool WithEditorOnlyData();
    bool SetActorTransientFlag(class AActor* Actor);
    bool IsDevicePropertyHandleValid(const FBlamHapticsEventHandle& InHandle);
    float GetWorldNorth(const class UObject* WorldContextObject, bool& bFound);
    class UBlamInputMapper* GetBlamInputMapper();
    class UMaterialInstanceDynamic* CreateMIDEditorOnly(class UMaterialInterface* Parent, class UObject* Outer, FName OptionalName);
}; // Size: 0x28

class UBlamEngineLoadingManagerEngineSubsystem : public UEngineSubsystem
{
    FBlamEngineLoadingManagerEngineSubsystemOnLoadStarted_BP OnLoadStarted_BP;        // 0x0030 (size: 0x10)
    void OnLoadStartedEvent_BP();
    FBlamEngineLoadingManagerEngineSubsystemOnLoadCompleted_BP OnLoadCompleted_BP;    // 0x0040 (size: 0x10)
    void OnLoadCompletedEvent_BP();
    FBlamEngineLoadingManagerEngineSubsystemOnLoadFailed_BP OnLoadFailed_BP;          // 0x0050 (size: 0x10)
    void OnLoadFailedEvent_BP();
    TOptional<FBlamScenarioGameOptions> ScenarioToLoadGameOptions;                    // 0x00E0 (size: 0x90)

    void OnLoadStartedEvent_BP__DelegateSignature();
    void OnLoadFailedEvent_BP__DelegateSignature();
    void OnLoadCompletedEvent_BP__DelegateSignature();
}; // Size: 0x1F8

class UBlamEnginePluginSettings : public UDeveloperSettings
{
    FDirectoryPath BlamEngineFolder;                                                  // 0x0038 (size: 0x10)
    EBlamEngineBuildConfiguration BuildConfiguration;                                 // 0x0048 (size: 0x4)
    EBlamEngineBuildConfiguration BuildConfigurationToolsDll;                         // 0x004C (size: 0x4)
    bool bDisableBlamEngine;                                                          // 0x0050 (size: 0x1)
    bool bDesireClangHaloSimulationDll;                                               // 0x0051 (size: 0x1)
    bool bUseTagIoIHandler;                                                           // 0x0052 (size: 0x1)
    bool bEditorEnableTagSystemShellSmokeTestsOnStartup;                              // 0x0053 (size: 0x1)
    bool bEditorSynchronization;                                                      // 0x0054 (size: 0x1)
    bool bShowSynchronizedObjectsInOutliner;                                          // 0x0055 (size: 0x1)
    uint8 NumSaveSlots;                                                               // 0x0056 (size: 0x1)

}; // Size: 0x58

class UBlamEngineSynchronizationManager : public UWorldSubsystem
{
}; // Size: 0x140

class UBlamFrontendLevelsEngineGlueSubsystem : public UBlamEngineGlueSubsystem
{
    class UBlamBuiltInMapInfoDataAsset* BuiltInMapInfoData;                           // 0x0040 (size: 0x8)

}; // Size: 0x188

class UBlamGameAllegianceSubsystem : public UBlamGameInstanceSubsystem
{
}; // Size: 0x100

class UBlamGameEngineBaseVariant : public UObject
{

    void SetSocialOptions(FBlamGameEngineSocialOptions SocialOptions);
    FBlamGameEngineSocialOptions GetSocialOptions();
}; // Size: 0x28

class UBlamGameEngineCampaignVariant : public UBlamGameEngineBaseVariant
{
    FBlamGameEngineCampaignVariantStorage CampaignVariantStorage;                     // 0x0028 (size: 0x60)

    void SetPerPlayerTraits(int32 CampaignPlayerIndex, FBlamGameEnginePlayerTraits PlayerTraits);
    void SetFlags(FBlamCampaignVariantFlags Flags);
    FBlamGameEnginePlayerTraits GetPerPlayerTraits(int32 CampaignPlayerIndex);
    FBlamCampaignVariantFlags GetFlags();
}; // Size: 0x88

class UBlamGameInstance : public UHaloOnlineGameInstance
{
}; // Size: 0x260

class UBlamGameInstanceSubsystem : public UGameInstanceSubsystem
{
}; // Size: 0x78

class UBlamGameStateObjectDebugMenuWidget : public UUserWidget
{
    FLinearColor BipedColor;                                                          // 0x02D0 (size: 0x10)
    FLinearColor ControlColor;                                                        // 0x02E0 (size: 0x10)
    FLinearColor CrateColor;                                                          // 0x02F0 (size: 0x10)
    FLinearColor CreatureColor;                                                       // 0x0300 (size: 0x10)
    FLinearColor EffectSceneryColor;                                                  // 0x0310 (size: 0x10)
    FLinearColor EquipmentColor;                                                      // 0x0320 (size: 0x10)
    FLinearColor GiantColor;                                                          // 0x0330 (size: 0x10)
    FLinearColor MachineColor;                                                        // 0x0340 (size: 0x10)
    FLinearColor ProjectileColor;                                                     // 0x0350 (size: 0x10)
    FLinearColor SceneryColor;                                                        // 0x0360 (size: 0x10)
    FLinearColor SoundSceneryColor;                                                   // 0x0370 (size: 0x10)
    FLinearColor TerminalColor;                                                       // 0x0380 (size: 0x10)
    FLinearColor VehicleColor;                                                        // 0x0390 (size: 0x10)
    FLinearColor WeaponColor;                                                         // 0x03A0 (size: 0x10)

}; // Size: 0x490

class UBlamGameUserSettings : public UHaloUserSettings
{
    FBlamGameUserSettingsOnBlamSettingsUpdated OnBlamSettingsUpdated;                 // 0x0500 (size: 0x10)
    void BlamGameUserSettingsUpdated();
    FString InProgress;                                                               // 0x0518 (size: 0x10)
    int32 SubtitlesEnabled;                                                           // 0x0528 (size: 0x4)
    FString SubtitleFriendlySpeakerColor;                                             // 0x0530 (size: 0x10)
    FString SubtitleEnemySpeakerColor;                                                // 0x0540 (size: 0x10)
    FString SubtitleNeutralSpeakerColor;                                              // 0x0550 (size: 0x10)
    FString SubtitleDialogueColor;                                                    // 0x0560 (size: 0x10)
    FString SubtitleFontWeight;                                                       // 0x0570 (size: 0x10)
    float SubtitleLetterSpacing;                                                      // 0x0580 (size: 0x4)
    float SubtitleLineSpacing;                                                        // 0x0584 (size: 0x4)
    FString SubtitleTextCaps;                                                         // 0x0588 (size: 0x10)
    FString SubtitleBackingColor;                                                     // 0x0598 (size: 0x10)
    float SubtitleBackingOpacity;                                                     // 0x05A8 (size: 0x4)
    EColorVisionDeficiency ColorCorrectionFilter;                                     // 0x05AC (size: 0x1)
    float ColorCorrectionStrength;                                                    // 0x05B0 (size: 0x4)
    float ColorCorrectionBrightness;                                                  // 0x05B4 (size: 0x4)
    float ColorCorrectionContrast;                                                    // 0x05B8 (size: 0x4)
    bool bTutorialTips;                                                               // 0x05BC (size: 0x1)
    bool bObjectiveHints;                                                             // 0x05BD (size: 0x1)
    FString ShowingHUDObjectives;                                                     // 0x05C0 (size: 0x10)
    FString ShowingHUDBanners;                                                        // 0x05D0 (size: 0x10)
    FString ShowingMenuToasts;                                                        // 0x05E0 (size: 0x10)
    bool bAnimatedMenuBackground;                                                     // 0x05F0 (size: 0x1)
    bool bFlashingEffects;                                                            // 0x05F1 (size: 0x1)
    bool bScreenShake;                                                                // 0x05F2 (size: 0x1)
    bool bMotionBlur;                                                                 // 0x05F3 (size: 0x1)
    float FrontendBackerOpacity;                                                      // 0x05F4 (size: 0x4)
    float IngameBackerOpacity;                                                        // 0x05F8 (size: 0x4)
    float CrosshairSize;                                                              // 0x05FC (size: 0x4)
    FString CrosshairColor;                                                           // 0x0600 (size: 0x10)
    FString CrosshairOverEnemyColor;                                                  // 0x0610 (size: 0x10)
    FString CrosshairOverFriendlyColor;                                               // 0x0620 (size: 0x10)
    float CrosshairOutlineOpacity;                                                    // 0x0630 (size: 0x4)
    float CrosshairOutlineThickness;                                                  // 0x0634 (size: 0x4)
    bool bHitMarkersEnabled;                                                          // 0x0638 (size: 0x1)
    float HUDWidgetScaling;                                                           // 0x063C (size: 0x4)
    float HUDBackingOpacity;                                                          // 0x0640 (size: 0x4)
    FString MotionTrackerEnemyColor;                                                  // 0x0648 (size: 0x10)
    FString MotionTrackerFriendlyColor;                                               // 0x0658 (size: 0x10)
    bool bHUDParallax;                                                                // 0x0668 (size: 0x1)
    float HUDGlitch;                                                                  // 0x066C (size: 0x4)
    float DamageScreenEffectsOpacity;                                                 // 0x0670 (size: 0x4)
    bool bChromaticAberration;                                                        // 0x0674 (size: 0x1)
    float DirectionalDamageIndicatorsOpacity;                                         // 0x0678 (size: 0x4)
    FString DirectionalDamageIndicatorsColor;                                         // 0x0680 (size: 0x10)
    float NavigationPointSize;                                                        // 0x0690 (size: 0x4)
    float NavigationPointOpacity;                                                     // 0x0694 (size: 0x4)
    FString NavigationPointColour;                                                    // 0x0698 (size: 0x10)
    float TeammateMarkerSize;                                                         // 0x06A8 (size: 0x4)
    float TeammateMarkerOpacity;                                                      // 0x06AC (size: 0x4)
    FString TeammateMarkerColour;                                                     // 0x06B0 (size: 0x10)
    FString SelectedControllerInputMappingPreset;                                     // 0x06C0 (size: 0x10)
    FString SelectedKBMInputMappingPreset;                                            // 0x06D0 (size: 0x10)
    bool bAllowInCoop;                                                                // 0x06E0 (size: 0x1)
    EModifierPresetSetting ModifierPreset;                                            // 0x06E1 (size: 0x1)
    FBlamGameEnginePlayerTraits PlayerTraits1;                                        // 0x06E2 (size: 0xC)
    FBlamGameEnginePlayerTraits PlayerTraits2;                                        // 0x06EE (size: 0xC)
    FBlamGameEnginePlayerTraits PlayerTraits3;                                        // 0x06FA (size: 0xC)
    FBlamGameEnginePlayerTraits PlayerTraits4;                                        // 0x0706 (size: 0xC)
    bool bFriendlyFire;                                                               // 0x0712 (size: 0x1)
    int32 FieldOfView;                                                                // 0x0714 (size: 0x4)
    int32 FieldOfView3rdPerson;                                                       // 0x0718 (size: 0x4)
    bool bHUDVisible;                                                                 // 0x071C (size: 0x1)
    float HUDOpacity;                                                                 // 0x0720 (size: 0x4)
    FString HUDAnchoring;                                                             // 0x0728 (size: 0x10)
    EHudLayoutSetting HUDLayout;                                                      // 0x0738 (size: 0x1)
    bool bFPSCounter;                                                                 // 0x0739 (size: 0x1)
    EHudNavpointDistanceUnitsSetting DistanceUnits;                                   // 0x073A (size: 0x1)
    bool bGoreBloodEnabled;                                                           // 0x073B (size: 0x1)
    int32 MeleeWeaponOffsetHorizontal;                                                // 0x073C (size: 0x4)
    int32 MeleeWeaponOffsetVertical;                                                  // 0x0740 (size: 0x4)
    int32 MeleeWeaponOffsetDepth;                                                     // 0x0744 (size: 0x4)
    int32 PistolOffsetHorizontal;                                                     // 0x0748 (size: 0x4)
    int32 PistolOffsetVertical;                                                       // 0x074C (size: 0x4)
    int32 PistolOffsetDepth;                                                          // 0x0750 (size: 0x4)
    int32 RifleOffsetHorizontal;                                                      // 0x0754 (size: 0x4)
    int32 RifleOffsetVertical;                                                        // 0x0758 (size: 0x4)
    int32 RifleOffsetDepth;                                                           // 0x075C (size: 0x4)
    int32 HeavyWeaponOffsetHorizontal;                                                // 0x0760 (size: 0x4)
    int32 HeavyWeaponOffsetVertical;                                                  // 0x0764 (size: 0x4)
    int32 HeavyWeaponOffsetDepth;                                                     // 0x0768 (size: 0x4)
    int32 HDR;                                                                        // 0x076C (size: 0x4)
    float Contrast;                                                                   // 0x0770 (size: 0x4)
    float Brightness;                                                                 // 0x0774 (size: 0x4)
    bool bVSync;                                                                      // 0x0778 (size: 0x1)
    bool bAsyncCompute;                                                               // 0x0779 (size: 0x1)
    EVideoFramerateSetting FrameRate;                                                 // 0x077A (size: 0x1)
    bool bFrameGeneration;                                                            // 0x077B (size: 0x1)
    EVideoLowLatencyMode LowLatencyMode;                                              // 0x077C (size: 0x1)
    int32 MinimumFrameRate;                                                           // 0x0780 (size: 0x4)
    int32 MaximumFrameRate;                                                           // 0x0784 (size: 0x4)
    FString Monitor;                                                                  // 0x0790 (size: 0x10)
    EVideoAspectRatioSetting AspectRatio;                                             // 0x07A0 (size: 0x1)
    bool bBorderlessFullscreen;                                                       // 0x07A1 (size: 0x1)
    float ResolutionScale;                                                            // 0x07A4 (size: 0x4)
    EVideoUpscalerSetting Upscaler;                                                   // 0x07A8 (size: 0x1)
    EVideoQualitySetting QualityPreset;                                               // 0x07A9 (size: 0x1)
    EVideoSwapChainProvider SwapChainProvider;                                        // 0x07AA (size: 0x1)
    EVideoUpscalingQualitySetting UpscalingQuality;                                   // 0x07AB (size: 0x1)
    EVideoQualitySetting TextureQuality;                                              // 0x07AC (size: 0x1)
    EVideoQualitySetting GeometryQuality;                                             // 0x07AD (size: 0x1)
    EVideoQualitySetting ReflectionsQuality;                                          // 0x07AE (size: 0x1)
    EVideoQualitySetting GlobalIlluminationQuality;                                   // 0x07AF (size: 0x1)
    EVideoQualitySetting LightingQuality;                                             // 0x07B0 (size: 0x1)
    EVideoQualitySetting EffectsQuality;                                              // 0x07B1 (size: 0x1)
    EVideoQualitySetting AtmosphericsQuality;                                         // 0x07B2 (size: 0x1)
    EVideoQualitySetting PostprocessingQuality;                                       // 0x07B3 (size: 0x1)
    FString VisualLanguage;                                                           // 0x07B8 (size: 0x10)
    float MouseLookSensitivity;                                                       // 0x07C8 (size: 0x4)
    float MouseLookSensitivityHorizontal;                                             // 0x07CC (size: 0x4)
    float MouseLookSensitivityVertical;                                               // 0x07D0 (size: 0x4)
    bool bMouseSmoothingEnabled;                                                      // 0x07D4 (size: 0x1)
    bool bMouseAccelerationEnabled;                                                   // 0x07D5 (size: 0x1)
    float MouseAccelerationScale;                                                     // 0x07D8 (size: 0x4)
    float MouseAccelerationMinRate;                                                   // 0x07DC (size: 0x4)
    float MouseAccelerationMaxRate;                                                   // 0x07E0 (size: 0x4)
    float MouseAccelerationExp;                                                       // 0x07E4 (size: 0x4)
    bool bMouseKeyboardInvertX;                                                       // 0x07E8 (size: 0x1)
    bool bMouseKeyboardInvertY;                                                       // 0x07E9 (size: 0x1)
    bool bMouseKeyboardFlightInvertX;                                                 // 0x07EA (size: 0x1)
    bool bMouseKeyboardFlightInvertY;                                                 // 0x07EB (size: 0x1)
    EBlamDrivingMode MouseKeyboardWarthogDrivingMode;                                 // 0x07EC (size: 0x1)
    bool bMouseKeyboardHoldToCrouch;                                                  // 0x07ED (size: 0x1)
    EBlamDrivingMode ControllerWarthogDrivingMode;                                    // 0x07EE (size: 0x1)
    bool bControllerHoldToCrouch;                                                     // 0x07EF (size: 0x1)
    bool bControllerAutoLookCentering;                                                // 0x07F0 (size: 0x1)
    bool bControllerAimMagnetism;                                                     // 0x07F1 (size: 0x1)
    EBlamLookSensitivity ControllerLookSensitivityHorizontal;                         // 0x07F2 (size: 0x1)
    EBlamLookSensitivity ControllerLookSensitivityVertical;                           // 0x07F3 (size: 0x1)
    EBlamJoystickPresets ControllerThumbstickLayout;                                  // 0x07F4 (size: 0x1)
    float ControllerLookAxialDeadZone;                                                // 0x07F8 (size: 0x4)
    float ControllerLookRadialDeadZone;                                               // 0x07FC (size: 0x4)
    EBlamLookAcceleration ControllerLookAcceleration;                                 // 0x0800 (size: 0x1)
    bool bControllerInvertX;                                                          // 0x0801 (size: 0x1)
    bool bControllerInvertY;                                                          // 0x0802 (size: 0x1)
    bool bControllerFlightInvertX;                                                    // 0x0803 (size: 0x1)
    bool bControllerFlightInvertY;                                                    // 0x0804 (size: 0x1)
    float ControllerVibration;                                                        // 0x0808 (size: 0x4)
    bool bControllerTriggerEffectsEnabled;                                            // 0x080C (size: 0x1)
    bool bControllerLightEffectsEnabled;                                              // 0x080D (size: 0x1)
    bool bControllerSpeaker;                                                          // 0x080E (size: 0x1)
    float VolumeControllerSpeaker;                                                    // 0x0810 (size: 0x4)
    FBlamCustomMappingContext CustomInputMappingGamepad;                              // 0x0818 (size: 0x20)
    FBlamCustomMappingContext CustomInputMappingKBM;                                  // 0x0838 (size: 0x20)
    TArray<FGameplayTag> ObjectCustomizationNames;                                    // 0x0858 (size: 0x10)

    void SetVSync(bool bNewValue);
    void SetVolumeControllerSpeaker(float NewValue);
    void SetUpscalingQualitySetting(EVideoUpscalingQualitySetting NewValue);
    void SetUpscaler(EVideoUpscalerSetting NewValue);
    void SetTextureQualitySetting(EVideoQualitySetting NewValue);
    void SetSelectedKBMInputMappingPreset(FString NewKBMInputMappingPreset);
    void SetSelectedControllerInputMappingPreset(FString NewControllerInputMappingPreset);
    void SetScreenShake(bool NewValue);
    void SetRifleOffsetVertical(int32 NewValue);
    void SetRifleOffsetHorizontal(int32 NewValue);
    void SetRifleOffsetDepth(int32 NewValue);
    void SetResolutionScale(float NewValue);
    void SetReflectionsQualitySetting(EVideoQualitySetting NewValue);
    void SetQualityPreset(EVideoQualitySetting NewValue);
    void SetPostprocessingQualitySetting(EVideoQualitySetting NewValue);
    void SetPistolOffsetVertical(int32 NewValue);
    void SetPistolOffsetHorizontal(int32 NewValue);
    void SetPistolOffsetDepth(int32 NewValue);
    void SetMouseSmoothingEnabled(bool bNewValue);
    void SetMouseLookSensitivityVertical(float NewValue);
    void SetMouseLookSensitivityHorizontal(float NewValue);
    void SetMouseLookSensitivity(float NewValue);
    void SetMouseKeyboardWarthogDrivingMode(EBlamDrivingMode NewValue);
    void SetMouseKeyboardInvertY(bool bNewValue);
    void SetMouseKeyboardInvertX(bool bNewValue);
    void SetMouseKeyboardHoldToCrouch(bool bNewValue);
    void SetMouseKeyboardFlightInvertY(bool bNewValue);
    void SetMouseKeyboardFlightInvertX(bool bNewValue);
    void SetMouseAccelerationScale(float NewValue);
    void SetMouseAccelerationMinRate(float NewValue);
    void SetMouseAccelerationMaxRate(float NewValue);
    void SetMouseAccelerationExp(float NewValue);
    void SetMouseAccelerationEnabled(bool bNewValue);
    void SetMotionBlur(bool NewValue);
    void SetMeleeWeaponOffsetVertical(int32 NewValue);
    void SetMeleeWeaponOffsetHorizontal(int32 NewValue);
    void SetMeleeWeaponOffsetDepth(int32 NewValue);
    void SetMaximumFrameRate(int32 NewValue);
    void SetLightingQualitySetting(EVideoQualitySetting NewValue);
    void SetHeavyWeaponOffsetVertical(int32 NewValue);
    void SetHeavyWeaponOffsetHorizontal(int32 NewValue);
    void SetHeavyWeaponOffsetDepth(int32 NewValue);
    void SetHDR(int32 NewValue);
    void SetGlobalIlluminationQualitySetting(EVideoQualitySetting NewValue);
    void SetGeometryQualitySetting(EVideoQualitySetting NewValue);
    void SetFrameGeneration(bool bNewValue);
    void SetEffectsQualitySetting(EVideoQualitySetting NewValue);
    void SetControllerWarthogDrivingMode(EBlamDrivingMode NewValue);
    void SetControllerVibration(float NewValue);
    void SetControllerTriggerEffectsEnabled(bool bNewValue);
    void SetControllerThumbstickLayout(EBlamJoystickPresets NewValue);
    void SetControllerSpeaker(bool NewValue);
    void SetControllerLookSensitivityVertical(EBlamLookSensitivity NewValue);
    void SetControllerLookSensitivityHorizontal(EBlamLookSensitivity NewValue);
    void SetControllerLookRadialDeadZone(float NewValue);
    void SetControllerLookAxialDeadZone(float NewValue);
    void SetControllerLookAcceleration(EBlamLookAcceleration NewValue);
    void SetControllerLightEffectsEnabled(bool bNewValue);
    void SetControllerInvertY(bool bNewValue);
    void SetControllerInvertX(bool bNewValue);
    void SetControllerHoldToCrouch(bool bNewValue);
    void SetControllerFlightInvertY(bool bNewValue);
    void SetControllerFlightInvertX(bool bNewValue);
    void SetControllerAutoLookCentering(bool bNewValue);
    void SetControllerAimMagnetism(bool bNewValue);
    void SetBorderlessFullscreenEnabled(bool bNewValue);
    void SetAtmosphericsQualitySetting(EVideoQualitySetting NewValue);
    bool GetVSyncEnabled();
    float GetVolumeControllerSpeaker();
    EVideoUpscalingQualitySetting GetUpscalingQualitySetting();
    EVideoUpscalerSetting GetUpscaler();
    EVideoQualitySetting GetTextureQualitySetting();
    FString GetSelectedKBMInputMappingPreset();
    FString GetSelectedControllerInputMappingPreset();
    bool GetScreenShake();
    int32 GetRifleOffsetVertical();
    int32 GetRifleOffsetHorizontal();
    int32 GetRifleOffsetDepth();
    float GetResolutionScale();
    EVideoQualitySetting GetReflectionsQualitySetting();
    EVideoQualitySetting GetQualityPreset();
    EVideoQualitySetting GetPostprocessingQualitySetting();
    int32 GetPistolOffsetVertical();
    int32 GetPistolOffsetHorizontal();
    int32 GetPistolOffsetDepth();
    bool GetMouseSmoothingEnabled();
    float GetMouseLookSensitivityVertical();
    float GetMouseLookSensitivityHorizontal();
    float GetMouseLookSensitivity();
    EBlamDrivingMode GetMouseKeyboardWarthogDrivingMode();
    bool GetMouseKeyboardInvertY();
    bool GetMouseKeyboardInvertX();
    bool GetMouseKeyboardHoldToCrouch();
    bool GetMouseKeyboardFlightInvertY();
    bool GetMouseKeyboardFlightInvertX();
    float GetMouseAccelerationScale();
    float GetMouseAccelerationMinRate();
    float GetMouseAccelerationMaxRate();
    float GetMouseAccelerationExp();
    bool GetMouseAccelerationEnabled();
    bool GetMotionBur();
    int32 GetMeleeWeaponOffsetVertical();
    int32 GetMeleeWeaponOffsetHorizontal();
    int32 GetMeleeWeaponOffsetDepth();
    int32 GetMaximumFrameRate();
    EVideoQualitySetting GetLightingQualitySetting();
    bool GetHudVisible();
    int32 GetHeavyWeaponOffsetVertical();
    int32 GetHeavyWeaponOffsetHorizontal();
    int32 GetHeavyWeaponOffsetDepth();
    int32 GetHDR();
    EVideoQualitySetting GetGlobalIlluminationQualitySetting();
    EVideoQualitySetting GetGeometryQualitySetting();
    EVideoFramerateSetting GetFrameRate();
    bool GetFrameGeneration();
    EVideoQualitySetting GetEffectsQualitySetting();
    EBlamDrivingMode GetControllerWarthogDrivingMode();
    float GetControllerVibration();
    bool GetControllerTriggerEffectsEnabled();
    EBlamJoystickPresets GetControllerThumbstickLayout();
    bool GetControllerSpeaker();
    EBlamLookSensitivity GetControllerLookSensitivityVertical();
    EBlamLookSensitivity GetControllerLookSensitivityHorizontal();
    float GetControllerLookRadialDeadZone();
    float GetControllerLookAxialDeadZone();
    EBlamLookAcceleration GetControllerLookAcceleration();
    bool GetControllerLightEffectsEnabled();
    bool GetControllerInvertY();
    bool GetControllerInvertX();
    bool GetControllerHoldToCrouch();
    bool GetControllerFlightInvertY();
    bool GetControllerFlightInvertX();
    bool GetControllerAutoLookCentering();
    bool GetControllerAimMagnetism();
    bool GetBorderlessFullscreenEnabled();
    EVideoQualitySetting GetAtmosphericsQualitySetting();
    FGameplayTag FindCustomizationMatching(FGameplayTag CustomizationToMatch);
    void ApplyVisualLanguage();
    void AddOrReplaceCustomization(FGameplayTag CustomizationToReplace, FGameplayTag NewSelection);
}; // Size: 0x868

class UBlamGamepadEventHandlerSubsystem : public UBlamGameInstanceSubsystem
{
    class UBlamGamepadLightEventDataAsset* LoadedLightEventsDataAsset;                // 0x00F0 (size: 0x8)

    void OnBlamIncident(const FBlamIncident& Incident);
    void AddGamepadLightEvent(const int32 LocalPlayerIndex, const FName EventName);
}; // Size: 0xF8

class UBlamGamepadLightEventDataAsset : public UDataAsset
{
    TArray<FGamepadLightEventData> LightEvents;                                       // 0x0030 (size: 0x10)

}; // Size: 0x40

class UBlamHapticsLocalPlayerSubsystem : public ULocalPlayerSubsystem
{

    void OnHardwareInputDeviceChanged(const FPlatformUserId UserId, const FInputDeviceId DeviceID);
}; // Size: 0x40

class UBlamIncidentHandlerLocalPlayerSubsystem : public ULocalPlayerSubsystem
{
}; // Size: 0x38

class UBlamIncidentSubsystem : public UBlamGameInstanceSubsystem
{
    FBlamIncidentSubsystemOnIncident OnIncident;                                      // 0x0078 (size: 0x10)
    void OnIncident(const FBlamIncident& Incident);

    void OnIncident__DelegateSignature(const FBlamIncident& Incident);
}; // Size: 0xA8

class UBlamInputAction : public UInputAction
{
    bool bAllowUnmappedAction;                                                        // 0x0078 (size: 0x1)
    uint32 ActionExclusivityContextFlags;                                             // 0x007C (size: 0x4)
    TSet<UBlamInputAction*> FriendInputActions;                                       // 0x0080 (size: 0x50)
    TSet<UInputMappingContext*> InvalidKeyMappings;                                   // 0x00D0 (size: 0x50)

}; // Size: 0x120

class UBlamInputActionsMapDataAsset : public UDataAsset
{
    TMap<class EBlamInputAction, class UBlamInputAction*> BlamInputActionsMap;        // 0x0030 (size: 0x50)

}; // Size: 0x80

class UBlamInputDeviceAudioVibrationProperty : public UInputDeviceProperty
{
}; // Size: 0x70

class UBlamInputDeviceForceFeedbackVibrationProperty : public UInputDeviceProperty
{
}; // Size: 0x68

class UBlamInputDeviceTriggerEffectProperty : public UInputDeviceTriggerEffect
{
}; // Size: 0x90

class UBlamInputDeviceTriggerResetProperty : public UInputDeviceTriggerEffect
{
}; // Size: 0x40

class UBlamInputDeviceTriggerVibrationProperty : public UInputDeviceTriggerEffect
{
}; // Size: 0x78

class UBlamInputMapper : public UObject
{
    FBlamInputMapperCreatedCustomPreset CreatedCustomPreset;                          // 0x0030 (size: 0x10)
    void OnCreatedCustomPreset(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    FBlamInputMapperUpdatedCustomPreset UpdatedCustomPreset;                          // 0x0040 (size: 0x10)
    void OnUpdatedCustomPreset(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    FBlamInputMapperOnAppliedPreset OnAppliedPreset;                                  // 0x0050 (size: 0x10)
    void OnAppliedPreset(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    TMap<class FName, class FBlamInputPreset> FixedInputPresets;                      // 0x0078 (size: 0x50)
    TSet<UBlamInputAction*> GamepadInputActions;                                      // 0x00C8 (size: 0x50)
    TSet<UBlamInputAction*> MouseAndKeyboardInputActions;                             // 0x0118 (size: 0x50)
    TArray<FBlamInputPreset> CustomInputPresetsGamepad;                               // 0x0168 (size: 0x10)
    TArray<FBlamInputPreset> CustomInputPresetsKBM;                                   // 0x0178 (size: 0x10)

    void UnmapKeyForBlamInputAction(const int32 LocalPlayerIndex, EBlamInputAction BlamInputAction, EBlamInputDeviceType InputDevice, EBlamKeyBindingSlot KeySlot);
    void UnmapAllConflictingBlamInputActionsFromKey(const int32 LocalPlayerIndex, FKey Key, const class UBlamInputAction* Action, EBlamInputDeviceType InputDevice, EBlamKeyBindingSlot KeySlot);
    EInputMapperErrorCode TryAndSetKeyForAction(const int32 LocalPlayerIndex, const class UBlamInputAction* Action, FKey NewKey, FInputMapperOutputErrorData& OutInputMapperOutputErrorData, EBlamKeyBindingSlot KeySlot, const bool bSkipExclusivity);
    bool SetSelectedPreset(const FName& PresetName, const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    EInputMapperErrorCode SetKeyForAction(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice, const class UBlamInputAction* Action, FKey NewKey, FInputMapperOutputErrorData& OutInputMapperOutputErrorData, EBlamKeyBindingSlot KeySlot, const bool bSkipExclusivity);
    bool SaveSelectedPreset(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    bool SaveCustomPreset(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    bool ResetCustomPreset(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    void OnUpdatedCustomPreset__DelegateSignature(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    void OnCreatedCustomPreset__DelegateSignature(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    void OnAppliedPreset__DelegateSignature(int32 LocalUserIndex, EBlamInputDeviceType InputDevice);
    bool IsCustomPresetValid(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    bool IsActionMappingValid(const int32 LocalPlayerIndex, const class UBlamInputAction* Action, EBlamInputDeviceType InputDevice, EBlamKeyBindingSlot KeySlot);
    FKey GetKeyForAction(const int32 LocalPlayerIndex, const class UBlamInputAction* Action, EBlamInputDeviceType InputDevice, EBlamKeyBindingSlot KeySlot);
    FBlamInputPreset GetFixedPreset(const FName PresetName, const int32 LocalPlayerIndex);
    FBlamInputPreset GetCustomPreset(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    FName GetBasePresetForCustomPreset(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
    bool CustomPresetDoesNotExistOrIsValid(const int32 LocalPlayerIndex, EBlamInputDeviceType InputDevice);
}; // Size: 0x270

class UBlamInputProcessorLocalPlayerSubsystem : public ULocalPlayerSubsystem
{

    void SetUIActive(const bool bUIActive);
}; // Size: 0x50

class UBlamLocalPlayer : public UHaloOnlineLocalPlayer
{

    void OnIncident(const FBlamIncident& Incident);
}; // Size: 0x2B8

class UBlamLocalUnitInventoryComponent : public UActorComponent
{
}; // Size: 0x1A8

class UBlamMetaDataSaveGame : public UBlamSaveGame
{
    int32 CurrentScenarioIndex;                                                       // 0x0030 (size: 0x4)
    FBlamScenarioGameOptions SavedScenarioGameOptions;                                // 0x0038 (size: 0x88)
    TSoftObjectPtr<UBlamCampaignDataAsset> CurrentCampaignDataAssetPtr;               // 0x00C0 (size: 0x28)
    FDateTime TimestampUTC;                                                           // 0x00E8 (size: 0x8)

}; // Size: 0xF0

class UBlamObjectCustomizationSubsystem : public UEngineSubsystem
{
}; // Size: 0x48

class UBlamPlayerEffectSubsystem : public UBlamGameInstanceSubsystem
{
    FBlamPlayerEffectSubsystemOnPlayerEffect OnPlayerEffect;                          // 0x0078 (size: 0x10)
    void OnPlayerEffect(const FBlamPlayerEffect& PlayerEffect);

    void OnPlayerEffect__DelegateSignature(const FBlamPlayerEffect& PlayerEffect);
}; // Size: 0x90

class UBlamPlayerMappableKeySettings : public UPlayerMappableKeySettings
{
    EBlamInputDeviceType InputDevice;                                                 // 0x0078 (size: 0x1)
    EBlamKeyBindingSlot BindingSlot;                                                  // 0x0079 (size: 0x1)
    bool bIgnore;                                                                     // 0x007A (size: 0x1)

}; // Size: 0x80

class UBlamProgressDataAsset : public UDataAsset
{
    FString ProgressSaveSlotName;                                                     // 0x0030 (size: 0x10)
    TSubclassOf<class UBlamProgressLocalPlayerSaveGame> ProgressSaveGameClass;        // 0x0040 (size: 0x8)
    FBlamIncidentNameToProgressMap IncidentToGameplayTags;                            // 0x0048 (size: 0x50)
    FBlamIncidentNameToMissionCompletionProgress MissionCompletionProgress;           // 0x0098 (size: 0xF0)

}; // Size: 0x188

class UBlamProgressLocalPlayerSaveGame : public ULocalPlayerSaveGame
{
    FBlamGameProgression GameProgression;                                             // 0x0058 (size: 0x4)
    FBlamGameProfile GameProfile;                                                     // 0x005C (size: 0x24)
    FGameplayTagContainer GameplayTags;                                               // 0x0080 (size: 0x20)
    FGameplayTagContainer NotifiedGameplayTags;                                       // 0x00A0 (size: 0x20)
    TArray<FString> OwnedPlayFabEntitlements;                                         // 0x00C0 (size: 0x10)

}; // Size: 0xD0

class UBlamProgressLocalPlayerSubsystem : public UBlamIncidentHandlerLocalPlayerSubsystem
{
    FBlamProgressLocalPlayerSubsystemOnProgressionIncident OnProgressionIncident;     // 0x0038 (size: 0x10)
    void OnProgressionIncident(FGameplayTag ProgressTag);

    void UpdateNotifiedGameplayTags();
    class UBlamProgressLocalPlayerSaveGame* TryAndGetSaveGame();
    void InjectProgressGameplayTag(const FGameplayTag& ProgressGameplayTag);
}; // Size: 0xE0

class UBlamRenderSettingsManagerGameInstanceSubsystem : public UGameInstanceSubsystem
{

    void OnRenderSettingsChanged__DelegateSignature(const FBlamRenderSettingsChangeData& UpdateData);
}; // Size: 0x60

class UBlamSaveGame : public USaveGame
{
    int32 SavedGameVersion;                                                           // 0x0028 (size: 0x4)

}; // Size: 0x30

class UBlamSaveGameBlueprintLibrary : public UBlueprintFunctionLibrary
{

    bool RemoveSaveGameTrackedActor(class AActor* Actor);
    bool AddSaveGameTrackedActor(class AActor* Actor);
    bool AddActorToBeDestroyedOnBlamReset(class AActor* Actor);
}; // Size: 0x28

class UBlamSaveGameWorldSubsystem : public UWorldSubsystem
{
}; // Size: 0x1D0

class UBlamSaveSlotSaveGame : public UBlamSaveGame
{
    class UBlamMetaDataSaveGame* MetaData;                                            // 0x0030 (size: 0x8)
    class UBlamDataSaveGame* BlamSaveGame;                                            // 0x0038 (size: 0x8)
    class UBlamUnrealWorldSaveGame* UnrealWorldSaveGame;                              // 0x0040 (size: 0x8)

}; // Size: 0x48

class UBlamSavedGameGameInstanceSubsystem : public UBlamGameInstanceSubsystem
{
}; // Size: 0xB8

class UBlamScenarioLifecycleEventsSubsystem : public UEngineSubsystem
{
}; // Size: 0x128

class UBlamScenarioObjectBindingComponent : public UActorComponent
{
    FBlamScenarioObjectBindingComponentOnObjectBoundEvent OnObjectBoundEvent;         // 0x00A8 (size: 0x10)
    void OnObjectBound(class AActor* NewBoundObjectActor, class AActor* OldBoundObjectActor);
    FBlamScenarioObjectBindingComponentOnObjectUnboundEvent OnObjectUnboundEvent;     // 0x00B8 (size: 0x10)
    void OnObjectUnbound(class AActor* OldBoundObjectActor);
    int32 ScenarioObjectIdentifier;                                                   // 0x00C8 (size: 0x4)

    class AActor* TryAndGetBoundObjectActor();
    void OnObjectUnbound__DelegateSignature(class AActor* OldBoundObjectActor);
    void OnObjectUnbound(class AActor* OldBoundObjectActor);
    void OnObjectBound__DelegateSignature(class AActor* NewBoundObjectActor, class AActor* OldBoundObjectActor);
    void OnObjectBound(class AActor* NewBoundObjectActor, class AActor* OldBoundObjectActor);
}; // Size: 0xE8

class UBlamSynchronizationHelperLibrary : public UBlueprintFunctionLibrary
{

    void SubmitMaterialResponseDataToResponseSubsystem(class UObject* WorldContextObject, const FHaloMaterialResponseData& MaterialResponseData);
    EBlamHelperLibrarySearchOutcome ResolvePlayerStateUsingBlamInputUserIndex(const class UObject* WorldContextObject, int32 RequestedBlamInputUserIndex, class APlayerState*& OutPlayerState);
    EResolveBlamAbsolutePlayerIndexResult ResolvePlayerStateUsingBlamAbsolutePlayerIndex(const class UObject* WorldContextObject, int32 RequestedBlamAbsolutePlayerIndex, class APlayerState*& OutPlayerState);
    EResolveBlamAbsolutePlayerIndexResult ResolveInGameBlamPlayerLocality(const class UObject* WorldContextObject, int32 RequestedPlayerDatumIndex);
    bool LocalPlayersStartCameraFade(const class UObject* WorldContextObject, bool bInFadingIn, float InFadeTimeInSeconds, FLinearColor InFadeColor, bool bInFadeAudio, bool bInHoldWhenFinished);
    EBlamHelperLibrarySearchOutcome GetWeaponBarrelFromEffectData(const FBlamEffectData& EffectData, EBlamWeaponBarrel& OutBarrel);
    FHaloMaterialResponseData GetMaterialResponseForEffect(class UObject* WorldContextObject, const FBlamEffectData& EffectData, const TEnumAsByte<ETraceTypeQuery> TraceChannel, EBlamHelperLibraryMaterialResolveOutcome& ResolveOutcome, const TArray<class AActor*>& ActorsToIgnore, const float RayCastLength);
    bool GetEffectSocketNamesFromMarkerGroup(class USkeleton* Skeleton, const FName MarkerGroupName, TArray<FName>& OutSocketNames);
    FName GetEffectSocketNameFromMarker(const FBlamEffectData& EffectData, class USkeleton* Skeleton, FName MarkerGroupName);
    FHaloMaterialResponseData GetAndSubmitMaterialResponseForEffect(class UObject* WorldContextObject, const FBlamEffectData& EffectData, const TEnumAsByte<ETraceTypeQuery> TraceChannel, EBlamHelperLibraryMaterialResolveOutcome& ResolveOutcome, const TArray<class AActor*>& ActorsToIgnore, const float RayCastLength);
    EBlamHelperLibrarySearchOutcome FindSurfaceGameplayTagForPhysicalMaterial(class UObject* WorldContextObject, class UPhysicalMaterial* PhysicalMaterial, FGameplayTag& OutMaterialGameplayTag);
    EBlamHelperLibrarySearchOutcome FindSurfaceFromEffectData(class UObject* WorldContextObject, const FBlamEffectData& EffectData, FHitResult& HitResult, const TArray<class AActor*>& ActorsToIgnore, const TEnumAsByte<ECollisionChannel> CollisionChannel, const float RayCastLength);
    EBlamHelperLibrarySearchOutcome FindPlayerStateUsingBlamAbsolutePlayerIndex(const class UObject* WorldContextObject, int32 RequestedBlamAbsolutePlayerIndex, class APlayerState*& OutPlayerState);
    EBlamHelperLibrarySearchOutcome FindMaterialImpactResponseData(class UObject* WorldContextObject, UClass* ResponseDataObjectClass, const FGameplayTag& MaterialGameplayTag, class UHaloMaterialResponseMapping* PrimaryMapping, class UHaloMaterialResponseMapping* OverrideMapping, TArray<class UObject*>& OutResponses);
    EBlamHelperLibrarySearchOutcome FindFirstMaterialImpactResponseData(class UObject* WorldContextObject, UClass* ResponseDataObjectClass, const FGameplayTag& MaterialGameplayTag, class UHaloMaterialResponseMapping* PrimaryMapping, class UHaloMaterialResponseMapping* OverrideMapping, class UObject*& OutResponse);
    EBlamHelperLibrarySearchOutcome FindEffectVectorByName(const FBlamEffectData& EffectData, FName Name, FBlamEffectVector& OutVector);
    bool ActorTeamIsTraitor(const class AActor* Actor, const class AActor* OtherActor);
    bool ActorTeamIsFriendly(const class AActor* Actor, const class AActor* OtherActor);
    bool ActorTeamIsEnemy(const class AActor* Actor, const class AActor* OtherActor);
    bool ActorTeamIsAlly(const class AActor* Actor, const class AActor* OtherActor);
}; // Size: 0x28

class UBlamTrackedActorsSaveGame : public UBlamSaveGame
{
}; // Size: 0x40

class UBlamUnrealWorldSaveGame : public UBlamSaveGame
{
    FBlamUnrealSavedState ActorState;                                                 // 0x0030 (size: 0x10)
    TMap<class FName, class UBlamSaveGame*> UnrealSaveGameSystems;                    // 0x0040 (size: 0x50)

}; // Size: 0x90

class UHaloMaterialResponseDataAsset : public UDataAsset
{
    TArray<class UObject*> ResponseDataArray;                                         // 0x0030 (size: 0x10)

}; // Size: 0x40

class UHaloMaterialResponseHandler : public UObject
{

    void BlueprintHandleMaterialResponse(const FHaloMaterialResponseData& InMaterialResponseData);
    void BlueprintGetSupportedResponseTags(FGameplayTagContainer& OutResponseTags);
}; // Size: 0x28

class UHaloMaterialResponseMapping : public UDataAsset
{
    class UHaloMaterialResponseMapping* ParentMapping;                                // 0x0030 (size: 0x8)
    TMap<class FGameplayTag, class UHaloMaterialResponseDataAsset*> DataAssetMap;     // 0x0038 (size: 0x50)

}; // Size: 0x88

class UHaloMaterialResponseSystemConfig : public UDeveloperSettings
{
    TArray<FSoftClassPath> DefaultMaterialHandlers;                                   // 0x0038 (size: 0x10)
    FSoftObjectPath PhysicalSurfaceToGameplayTagTable;                                // 0x0048 (size: 0x20)

}; // Size: 0x68

class UHaloMaterialResponseWorldSubsystem : public UWorldSubsystem
{
    TSet<UHaloMaterialResponseHandler*> RegisteredHandlers;                           // 0x0030 (size: 0x50)
    class UDataTable* PhysicalMaterialNameToGameplayTagDataTable;                     // 0x00D0 (size: 0x8)

}; // Size: 0x138

class UScenarioInsertionPointAsset : public UPrimaryDataAsset
{
    TArray<FScenarioInsertionPoint> InsertionPoints;                                  // 0x0030 (size: 0x10)

}; // Size: 0x40

class UScenarioUserInterfaceObjectiveAsset : public UPrimaryDataAsset
{
    TArray<FScenarioUserInterfaceObjective> Objectives;                               // 0x0030 (size: 0x10)

}; // Size: 0x40

#endif

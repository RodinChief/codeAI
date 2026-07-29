#ifndef UE4SS_SDK_Meteorite_HPP
#define UE4SS_SDK_Meteorite_HPP

#include "Meteorite_enums.hpp"

struct FAlertDataRow : public FTableRowBase
{
    FText Title;                                                                      // 0x0008 (size: 0x10)
    FText Message;                                                                    // 0x0018 (size: 0x10)

}; // Size: 0x28

struct FBlamAimAssistInfo
{
    class AActor* TargetedActor;                                                      // 0x0000 (size: 0x8)
    class AActor* FullyTargetedActor;                                                 // 0x0008 (size: 0x8)
    float PrimaryAutoAimLevel;                                                        // 0x0010 (size: 0x4)
    FBlamAutoAimFlags AutoAimFlags;                                                   // 0x0014 (size: 0x4)

}; // Size: 0x18

struct FBlamGlobalHud
{
    FBlamHudCountdown HudCountdown;                                                   // 0x0000 (size: 0x8)

}; // Size: 0x8

struct FBlamInteraction
{
    FText Message;                                                                    // 0x0000 (size: 0x10)
    float Progress;                                                                   // 0x0010 (size: 0x4)
    class AActor* InteractionActor;                                                   // 0x0018 (size: 0x8)
    EBlamInteractPromptButtonAction Action;                                           // 0x0020 (size: 0x1)
    EBlamInteractPromptSeatType SeatType;                                             // 0x0021 (size: 0x1)

}; // Size: 0x28

struct FBlamInteractionInfo
{
    FBlamInteraction PrimaryInteraction;                                              // 0x0000 (size: 0x28)
    FBlamInteraction SecondaryInteraction;                                            // 0x0028 (size: 0x28)

}; // Size: 0x50

struct FBlamPlayerTraining
{
    FName TrainingName;                                                               // 0x0000 (size: 0x8)

}; // Size: 0x8

struct FBlamScriptedNavpoint
{
    int32 Identifier;                                                                 // 0x0000 (size: 0x4)
    class AActor* Actor;                                                              // 0x0008 (size: 0x8)
    bool bPositionedOnActor;                                                          // 0x0010 (size: 0x1)
    FVector OffsetWorldspace;                                                         // 0x0018 (size: 0x18)
    EBlamScriptedNavpointPriority Priority;                                           // 0x0030 (size: 0x1)
    FText Label;                                                                      // 0x0038 (size: 0x10)

}; // Size: 0x48

struct FBlamTargetPoint
{
    bool bIsValid;                                                                    // 0x0000 (size: 0x1)
    FVector PositionWorldspace;                                                       // 0x0008 (size: 0x18)

}; // Size: 0x20

struct FBlamTrackedTarget
{
    FBlamTargetPoint TargetPoint;                                                     // 0x0000 (size: 0x20)
    bool bIsLocked;                                                                   // 0x0020 (size: 0x1)
    float LockingTheta;                                                               // 0x0024 (size: 0x4)

}; // Size: 0x28

struct FBlamUserInterfaceObjectiveState
{
    FText ObjectiveName;                                                              // 0x0000 (size: 0x10)
    EBlamUserInterfaceObjectiveState State;                                           // 0x0010 (size: 0x1)

}; // Size: 0x18

struct FBlamUserInterfaceObjectives
{
    EBlamUserInterfaceObjectiveChangeType ChangeType;                                 // 0x0000 (size: 0x1)
    TArray<FBlamUserInterfaceObjectiveState> ObjectivesList;                          // 0x0008 (size: 0x10)
    bool bAllCompleted;                                                               // 0x0018 (size: 0x1)
    bool bAllHidden;                                                                  // 0x0019 (size: 0x1)

}; // Size: 0x20

struct FCustomizationEntitlementRow : public FTableRowBase
{
    FString SteamCode;                                                                // 0x0008 (size: 0x10)
    FString SteamStoreCode;                                                           // 0x0018 (size: 0x10)
    FString XboxCode;                                                                 // 0x0028 (size: 0x10)
    FString XboxStoreCode;                                                            // 0x0038 (size: 0x10)
    FString PSNCode;                                                                  // 0x0048 (size: 0x10)
    FString PSNStoreCode;                                                             // 0x0058 (size: 0x10)
    FString WaypointEntitlementName;                                                  // 0x0068 (size: 0x10)

}; // Size: 0x78

struct FDamageIndicatorDamageInstance
{
    class AActor* DamageOwnerObject;                                                  // 0x0000 (size: 0x8)
    FVector DamageOrigin;                                                             // 0x0008 (size: 0x18)
    float Scale;                                                                      // 0x0020 (size: 0x4)
    float BodyDamage;                                                                 // 0x0024 (size: 0x4)
    float ShieldDamage;                                                               // 0x0028 (size: 0x4)
    float NormalizedDamage;                                                           // 0x002C (size: 0x4)
    float NormalizedAccumulatedDamage;                                                // 0x0030 (size: 0x4)
    float Yaw;                                                                        // 0x0034 (size: 0x4)
    float LifeTime;                                                                   // 0x0038 (size: 0x4)
    float CreationTime;                                                               // 0x003C (size: 0x4)
    float EndTime;                                                                    // 0x0040 (size: 0x4)

}; // Size: 0x48

struct FDamageIndicatorInstances
{
    TArray<FDamageIndicatorDamageInstance> DamageInstances;                           // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FGameInfo
{
    bool bValid;                                                                      // 0x0000 (size: 0x1)
    EBlamCampaignDifficultyLevel CampaignDifficultyLevel;                             // 0x0001 (size: 0x1)
    EModifierPresetSetting ModifierPreset;                                            // 0x0002 (size: 0x1)
    TSet<EBlamGameSkulls> ActiveSkulls;                                               // 0x0008 (size: 0x50)

}; // Size: 0x58

struct FGetLinkedAccountResult
{
    TArray<class ULinkedAccount*> LinkedAccounts;                                     // 0x0000 (size: 0x10)

}; // Size: 0x10

struct FInProgressDataRow : public FTableRowBase
{
    FText Title;                                                                      // 0x0008 (size: 0x10)
    FText Message;                                                                    // 0x0018 (size: 0x10)

}; // Size: 0x28

struct FMeteoriteAccountAlias
{
    FText DisplayName;                                                                // 0x0000 (size: 0x10)
    int32 PlatformId;                                                                 // 0x0010 (size: 0x4)

}; // Size: 0x18

struct FPlayerNameRecord
{
    class APlayerState* PlayerState;                                                  // 0x0000 (size: 0x8)
    FText PlayerName;                                                                 // 0x0008 (size: 0x10)

}; // Size: 0x18

struct FRequiredSetting
{
    FGameplayTag SettingTag;                                                          // 0x0000 (size: 0x8)
    ESettingsValueComparison ComparisonType;                                          // 0x0008 (size: 0x1)
    int32 ComparisonValue;                                                            // 0x000C (size: 0x4)

}; // Size: 0x10

struct FResumeCampaignUIInfo
{
    EBlamGameModeSaveSlot SaveSlot;                                                   // 0x0000 (size: 0x1)
    FString Mission;                                                                  // 0x0008 (size: 0x10)
    FString InsertionPoint;                                                           // 0x0018 (size: 0x10)
    EBlamCampaignDifficultyLevel Difficulty;                                          // 0x0028 (size: 0x1)

}; // Size: 0x30

struct FRosterFriendInfo
{
    FString DisplayName;                                                              // 0x0008 (size: 0x10)
    FString Nickname;                                                                 // 0x0018 (size: 0x10)
    ERosterPresenceStatus PresenceStatus;                                             // 0x0028 (size: 0x1)
    FString RichPresenceString;                                                       // 0x0030 (size: 0x10)
    ERosterFriendPlatformType PlatformType;                                           // 0x0040 (size: 0x1)
    bool IsJoinable;                                                                  // 0x0041 (size: 0x1)

}; // Size: 0x48

struct FSaveSlotCampaignUIInfo
{
    EBlamGameModeSaveSlot SaveSlot;                                                   // 0x0000 (size: 0x1)
    FText Mission;                                                                    // 0x0008 (size: 0x10)
    FText InsertionPoint;                                                             // 0x0018 (size: 0x10)
    EBlamCampaignDifficultyLevel Difficulty;                                          // 0x0028 (size: 0x1)
    EBlamCampaignType BlamCampaignType;                                               // 0x0029 (size: 0x1)
    FDateTime TimestampUTC;                                                           // 0x0030 (size: 0x8)

}; // Size: 0x38

struct FScreenReaderRate
{
    FGameplayTag Tag;                                                                 // 0x0000 (size: 0x8)
    float Rate;                                                                       // 0x0008 (size: 0x4)

}; // Size: 0xC

struct FSettingsItemDataExtensionProperties
{
    TArray<FRequiredSetting> RequiredSettings;                                        // 0x0000 (size: 0x10)
    int32 UserIndex;                                                                  // 0x0010 (size: 0x4)

}; // Size: 0x18

struct FToastAsyncNodePair
{
    class UMeteoriteToastInitData* Key;                                               // 0x0000 (size: 0x8)
    class UMeteoriteToastAsyncNodeBase* Value;                                        // 0x0008 (size: 0x8)

}; // Size: 0x10

struct FVoiceChatFadeTimerSeconds
{
    FGameplayTag Tag;                                                                 // 0x0000 (size: 0x8)
    float Timer;                                                                      // 0x0008 (size: 0x4)

}; // Size: 0xC

class AMeteoriteCharacter : public ACharacter
{
    class USkeletalMeshComponent* Mesh1P;                                             // 0x0678 (size: 0x8)
    class UCameraComponent* FirstPersonCameraComponent;                               // 0x0680 (size: 0x8)
    class UInputMappingContext* DefaultMappingContext;                                // 0x0688 (size: 0x8)
    class UInputAction* JumpAction;                                                   // 0x0690 (size: 0x8)
    class UInputAction* MoveAction;                                                   // 0x0698 (size: 0x8)
    class UInputAction* LookAction;                                                   // 0x06A0 (size: 0x8)
    bool bHasRifle;                                                                   // 0x06A8 (size: 0x1)

    void SetHasRifle(bool bNewHasRifle);
    bool GetHasRifle();
}; // Size: 0x6B0

class AMeteoriteGameMode : public ABlamGameMode
{
}; // Size: 0x3A8

class AMeteoriteHUD : public ABlamHUD
{
    FBlamReticleInfo ReticleInfo;                                                     // 0x03C8 (size: 0x10)
    FBlamAimAssistInfo AimAssistInfo;                                                 // 0x03D8 (size: 0x18)
    FBlamInteractionInfo InteractionInfo;                                             // 0x03F0 (size: 0x50)
    TArray<FBlamScriptedNavpoint> ScriptedNavpoints;                                  // 0x0440 (size: 0x10)
    FBlamHudScripting HudScriptingInfo;                                               // 0x0450 (size: 0x4)
    FBlamTargetPoint GhostTarget;                                                     // 0x0458 (size: 0x20)
    FBlamTrackedTarget TrackedTarget;                                                 // 0x0478 (size: 0x28)
    FBlamPlayerTraining PlayerTrainingInfo;                                           // 0x04A0 (size: 0x8)
    FBlamPlayerRespawn PlayerRespawnInfo;                                             // 0x04A8 (size: 0xC)
    FBlamGameEngineTimer OutOfBoundsInfo;                                             // 0x04B4 (size: 0x8)
    FBlamGlobalHud GlobalHudData;                                                     // 0x04BC (size: 0x8)
    float AutoAimTargetLevel;                                                         // 0x04C4 (size: 0x4)
    FLinearColor FadeColor;                                                           // 0x04C8 (size: 0x10)
    float FadeOpacity;                                                                // 0x04D8 (size: 0x4)
    FMeteoriteHUDChangedAimAssistTargetDelegate ChangedAimAssistTargetDelegate;       // 0x04E0 (size: 0x10)
    void ChangedActor(class AActor* NewActor, class AActor* PreviousActor);
    FMeteoriteHUDChangedHeadshotStateDelegate ChangedHeadshotStateDelegate;           // 0x04F0 (size: 0x10)
    void BoolValueChanged(bool NewValue);
    FMeteoriteHUDChangedErrorConeRadiusDelegate ChangedErrorConeRadiusDelegate;       // 0x0500 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FMeteoriteHUDChangeCountdownTimeDelegate ChangeCountdownTimeDelegate;             // 0x0510 (size: 0x10)
    void IntValueChanged(int32 NewValue);
    FMeteoriteHUDChangeCountdownStateDelegate ChangeCountdownStateDelegate;           // 0x0520 (size: 0x10)
    void CountdownStateValueChanged(EBlamHudCountdownState NewValue);
    FMeteoriteHUDChangedPrimaryInteractionProgressDelegate ChangedPrimaryInteractionProgressDelegate; // 0x0530 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FMeteoriteHUDChangedPrimaryInteractionTextDelegate ChangedPrimaryInteractionTextDelegate; // 0x0540 (size: 0x10)
    void InteractionTextChanged(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    FMeteoriteHUDChangedSecondaryInteractionProgressDelegate ChangedSecondaryInteractionProgressDelegate; // 0x0550 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FMeteoriteHUDChangedSecondaryInteractionTextDelegate ChangedSecondaryInteractionTextDelegate; // 0x0560 (size: 0x10)
    void InteractionTextChanged(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    FMeteoriteHUDChangedScriptedNavpointsDelegate ChangedScriptedNavpointsDelegate;   // 0x0570 (size: 0x10)
    void ChangedScriptedNavpoints(const TArray<FBlamScriptedNavpoint>& NewScriptedNavpoints);
    FMeteoriteHUDChangedPlayerTrainingDelegate ChangedPlayerTrainingDelegate;         // 0x0580 (size: 0x10)
    void NameValueChanged(FName NewValue);
    FMeteoriteHUDHudBannerMessageDelegate HudBannerMessageDelegate;                   // 0x0590 (size: 0x10)
    void TextValueChanged(FText NewValue);
    FMeteoriteHUDGhostTargetChangedDelegate GhostTargetChangedDelegate;               // 0x05A0 (size: 0x10)
    void BlamTargetPointChanged(FBlamTargetPoint NewValue);
    FMeteoriteHUDTrackedTargetChangedDelegate TrackedTargetChangedDelegate;           // 0x05B0 (size: 0x10)
    void BlamTrackedTargetChanged(FBlamTrackedTarget NewValue);
    FMeteoriteHUDChangedPlayerRespawnFailureDelegate ChangedPlayerRespawnFailureDelegate; // 0x05C0 (size: 0x10)
    void ChangedPlayerRespawnFailure(EBlamPlayerRespawnFailure NewValue);
    FMeteoriteHUDChangedPlayerRespawnViewedPlayerDelegate ChangedPlayerRespawnViewedPlayerDelegate; // 0x05D0 (size: 0x10)
    void ChangedPlayerRespawnViewedPlayer(const class APlayerState* NewValue);
    FMeteoriteHUDChangedPlayerRespawnTimerDelegate ChangedPlayerRespawnTimerDelegate; // 0x05E0 (size: 0x10)
    void IntValueChanged(int32 NewValue);
    FMeteoriteHUDChangedOutOfBoundsTimerDelegate ChangedOutOfBoundsTimerDelegate;     // 0x05F0 (size: 0x10)
    void IntValueChanged(int32 NewValue);
    FMeteoriteHUDChangedFadeColorDelegate ChangedFadeColorDelegate;                   // 0x0600 (size: 0x10)
    void FadeColorChanged(FLinearColor NewValue);
    FMeteoriteHUDChangedFadeOpacityDelegate ChangedFadeOpacityDelegate;               // 0x0610 (size: 0x10)
    void FadeOpacityChanged(float NewValue);

    void TextValueChanged__DelegateSignature(FText NewValue);
    void NameValueChanged__DelegateSignature(FName NewValue);
    void IntValueChanged__DelegateSignature(int32 NewValue);
    void InteractionTextChanged__DelegateSignature(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    void FloatValueChanged__DelegateSignature(float NewValue);
    void FadeOpacityChanged__DelegateSignature(float NewValue);
    void FadeColorChanged__DelegateSignature(FLinearColor NewValue);
    void CountdownStateValueChanged__DelegateSignature(EBlamHudCountdownState NewValue);
    void ChangedScriptedNavpoints__DelegateSignature(const TArray<FBlamScriptedNavpoint>& NewScriptedNavpoints);
    void ChangedPlayerRespawnViewedPlayer__DelegateSignature(const class APlayerState* NewValue);
    void ChangedPlayerRespawnFailure__DelegateSignature(EBlamPlayerRespawnFailure NewValue);
    void ChangedActor__DelegateSignature(class AActor* NewActor, class AActor* PreviousActor);
    void BoolValueChanged__DelegateSignature(bool NewValue);
    void BlamTrackedTargetChanged__DelegateSignature(FBlamTrackedTarget NewValue);
    void BlamTargetPointChanged__DelegateSignature(FBlamTargetPoint NewValue);
}; // Size: 0x648

class AMeteoritePlayerController : public ABlamPlayerController
{
    class UMeteoriteAutomatorComponent* InputAutomator;                               // 0x0970 (size: 0x8)

    void SetInputEnabled(bool bEnabled);
    void SetGameAndBlamPaused(const class UObject* WorldContextObject, bool bPause);
}; // Size: 0x978

class AMeteoritePlayerState : public ABlamPlayerState
{
}; // Size: 0x3B0

class AMeteoriteProjectile : public AActor
{
    class USphereComponent* CollisionComp;                                            // 0x02D8 (size: 0x8)
    class UProjectileMovementComponent* ProjectileMovement;                           // 0x02E0 (size: 0x8)

    void OnHit(class UPrimitiveComponent* HitComp, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, FVector NormalImpulse, const FHitResult& Hit);
}; // Size: 0x2E8

class ASwarmContainmentVolume : public AActor
{
    class UBoxComponent* BoxComponent;                                                // 0x02D8 (size: 0x8)

}; // Size: 0x2E0

class ASwarmObstacleDynamicVolume : public AActor
{
    class USphereComponent* SphereComponent;                                          // 0x02D8 (size: 0x8)

}; // Size: 0x2E0

class ASwarmObstacleManager : public AActor
{
    TArray<class AActor*> SwarmActors;                                                // 0x02D8 (size: 0x10)
    TArray<class ASwarmObstacleVolume*> Obstacles;                                    // 0x02E8 (size: 0x10)
    TArray<class ASwarmObstacleDynamicVolume*> DynamicObstacles;                      // 0x02F8 (size: 0x10)
    TArray<class ASwarmContainmentVolume*> ContainmentVolumes;                        // 0x0308 (size: 0x10)

    void UnsubscribeSwarmActor(class AActor* SwarmActor);
    void UnsetContainmentVolume(const class ASwarmContainmentVolume* Volume);
    void UnregisterObstacle(const class ASwarmObstacleVolume* Obstacle);
    void UnregisterDynamicObstacle(const class ASwarmObstacleDynamicVolume* Obstacle);
    void SubscribeSwarmActor(class AActor* SwarmActor);
    void SetContainmentVolume(const class ASwarmContainmentVolume* Volume);
    void RegisterObstacle(const class ASwarmObstacleVolume* Obstacle);
    void RegisterDynamicObstacle(const class ASwarmObstacleDynamicVolume* Obstacle);
}; // Size: 0x318

class ASwarmObstacleVolume : public AVolume
{
}; // Size: 0x310

class IMeteoriteGetFriendsListPageInterface : public IInterface
{

    class UMeteoriteFriendsListPage* GetMeteoriteFriendsListPage();
}; // Size: 0x28

class ISettingsItemDataExtension : public IInterface
{

    void SetUserIndex(int32 UserIndex);
    bool HasAnyRequiredSettings();
    class UMeteoriteGameUserSettings* GetUserSettingsBP();
    TArray<FName> GetRequiredSettingNames();
}; // Size: 0x28

class UDebugMenuSettings : public UDeveloperSettings
{
    bool bEnableDebugMenuBetaShipping;                                                // 0x0038 (size: 0x1)
    bool bEnableDebugMenuBetaNonShipping;                                             // 0x0039 (size: 0x1)
    bool bEnableDebugMenuReleaseShipping;                                             // 0x003A (size: 0x1)
    bool bEnableDebugMenuReleaseNonShipping;                                          // 0x003B (size: 0x1)
    bool bEnableDebugMenuDefaultShipping;                                             // 0x003C (size: 0x1)
    bool bEnableDebugMenuDefaultNonShipping;                                          // 0x003D (size: 0x1)

    bool GetDebugMenuEnabled();
}; // Size: 0x40

class UGameFeedbackSettings : public UDeveloperSettings
{
    bool bEnableGameFeedbackBetaShipping;                                             // 0x0038 (size: 0x1)
    bool bEnableGameFeedbackBetaNonShipping;                                          // 0x0039 (size: 0x1)
    bool bEnableGameFeedbackReleaseShipping;                                          // 0x003A (size: 0x1)
    bool bEnableGameFeedbackReleaseNonShipping;                                       // 0x003B (size: 0x1)
    bool bEnableGameFeedbackDefaultShipping;                                          // 0x003C (size: 0x1)
    bool bEnableGameFeedbackDefaultNonShipping;                                       // 0x003D (size: 0x1)

    bool GetGameFeedbackEnabled();
}; // Size: 0x40

class UHudDataAsset : public UPrimaryDataAsset
{
}; // Size: 0x30

class UHudDataAssetBanner : public UHudDataAsset
{
    FHudDataAssetBannerBannerMessageDelegate BannerMessageDelegate;                   // 0x0030 (size: 0x10)
    void TextValueChanged(FText NewValue);
    FHudDataAssetBannerPlayerLeftDelegate PlayerLeftDelegate;                         // 0x0040 (size: 0x10)
    void TextValueChanged(FText NewValue);

    void OnPlayerLeft(FText PlayerName);
    void OnBannerMessageReceived(FText BannerMessage);
}; // Size: 0x50

class UHudDataAssetCountdown : public UHudDataAsset
{
    FHudDataAssetCountdownTimeChangedDelegate TimeChangedDelegate;                    // 0x0038 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FHudDataAssetCountdownStateChangedDelegate StateChangedDelegate;                  // 0x0048 (size: 0x10)
    void CountdownStateValueChanged(EBlamHudCountdownState NewValue);
    EBlamHudCountdownState CurrentState;                                              // 0x0058 (size: 0x1)
    int32 NetworkedTime;                                                              // 0x005C (size: 0x4)
    float DisplayTime;                                                                // 0x0060 (size: 0x4)

    void OnChangedCountdownTime(int32 NewTime);
    void OnChangedCountdownState(EBlamHudCountdownState NewState);
}; // Size: 0x70

class UHudDataAssetDirectionalDamage : public UHudDataAsset
{
    FHudDataAssetDirectionalDamageDirectionalDamageDataChanged DirectionalDamageDataChanged; // 0x0038 (size: 0x10)
    void DataChanged();
    FDamageIndicatorInstances DamageIndicatorInstances;                               // 0x0048 (size: 0x10)
    float DefaultDuration;                                                            // 0x0058 (size: 0x4)
    TWeakObjectPtr<class ULocalPlayer> WeakLocalPlayerReference;                      // 0x005C (size: 0x8)

    void OnPlayerEffect(const FBlamPlayerEffect& PlayerEffect);
    void DataChanged__DelegateSignature();
}; // Size: 0x68

class UHudDataAssetEquipment : public UHudDataAsset
{
    FHudDataAssetEquipmentChangedEquipmentDelegate ChangedEquipmentDelegate;          // 0x0030 (size: 0x10)
    void ChangedEquipment(const class UBlamEquipmentComponent* NewEquipment, const class UBlamEquipmentComponent* PreviousEquipment);
    FHudDataAssetEquipmentOnActivatedDelegate OnActivatedDelegate;                    // 0x0040 (size: 0x10)
    void OnActivated(EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetEquipmentOnWarmedUpDelegate OnWarmedUpDelegate;                      // 0x0050 (size: 0x10)
    void OnWarmedUp(EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetEquipmentOnDeactivatedDelegate OnDeactivatedDelegate;                // 0x0060 (size: 0x10)
    void OnDeactivated(EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetEquipmentOnStrengthDepletedDelegate OnStrengthDepletedDelegate;      // 0x0070 (size: 0x10)
    void OnStrengthDepleted(EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetEquipmentOnActiveFractionChangedDelegate OnActiveFractionChangedDelegate; // 0x0080 (size: 0x10)
    void OnActiveFractionChanged(float DeltaActiveFraction, EBlamPropertyChangeReason BlamPropertyChangeReason);
    class UBlamEquipmentComponent* CachedPreviousEquipment;                           // 0x0090 (size: 0x8)

    void OnWarmedUp(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnStrengthDepleted(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnDeactivated(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnChangedEquipment(const class UBlamEquipmentComponent* NewEquipment, const class UBlamEquipmentComponent* PreviousEquipment);
    void OnActiveFractionChanged(float DeltaActiveFraction, EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnActivated(EBlamPropertyChangeReason BlamPropertyChangeReason);
}; // Size: 0x98

class UHudDataAssetGrenadeCradle : public UHudDataAsset
{
    FHudDataAssetGrenadeCradleChangedInventoryDelegate ChangedInventoryDelegate;      // 0x0030 (size: 0x10)
    void ChangedInventory(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    FHudDataAssetGrenadeCradleOnCurrentGrenadeChangedDelegate OnCurrentGrenadeChangedDelegate; // 0x0040 (size: 0x10)
    void OnCurrentGrenadeChanged(int32 PreviousGrenadeInventoryIndex, int32 GrenadeInventoryIndex, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetGrenadeCradleOnGrenadeCountChangedDelegate OnGrenadeCountChangedDelegate; // 0x0050 (size: 0x10)
    void OnGrenadeCountChanged(int32 GrenadeInventoryIndex, int32 DeltaCount, EBlamPropertyChangeReason BlamPropertyChangeReason);

    void OnInventoryChanged(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    void OnGrenadeCountChanged(int32 GrenadeInventoryIndex, int32 DeltaCount, EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnCurrentGrenadeChanged(int32 PreviousGrenadeInventoryIndex, int32 GrenadeInventoryIndex, EBlamPropertyChangeReason BlamPropertyChangeReason);
}; // Size: 0x60

class UHudDataAssetInteractions : public UHudDataAsset
{
    FHudDataAssetInteractionsChangedPrimaryInteractionProgressDelegate ChangedPrimaryInteractionProgressDelegate; // 0x0030 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FHudDataAssetInteractionsChangedPrimaryInteractionTextDelegate ChangedPrimaryInteractionTextDelegate; // 0x0040 (size: 0x10)
    void InteractionTextChanged(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    FHudDataAssetInteractionsChangedSecondaryInteractionProgressDelegate ChangedSecondaryInteractionProgressDelegate; // 0x0050 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FHudDataAssetInteractionsChangedSecondaryInteractionTextDelegate ChangedSecondaryInteractionTextDelegate; // 0x0060 (size: 0x10)
    void InteractionTextChanged(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);

    void OnChangedSecondaryInteractionText(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    void OnChangedSecondaryInteractionProgress(float NewValue);
    void OnChangedPrimaryInteractionText(FText NewValue, class AActor* NewActor, EBlamInteractPromptButtonAction NewAction, EBlamInteractPromptSeatType NewSeatType);
    void OnChangedPrimaryInteractionProgress(float NewValue);
}; // Size: 0x70

class UHudDataAssetNavpoints : public UHudDataAsset
{
    TSubclassOf<class UUserWidget> ObjectivesNavpointWidgetClass;                     // 0x0040 (size: 0x8)
    TMap<class EBlamScriptedNavpointPriority, class TSubclassOf<UUserWidget>> ObjectivesNavpointWidgetClassByPriority; // 0x0048 (size: 0x50)
    TSubclassOf<class UUserWidget> PlayerNavpointWidgetClass;                         // 0x0098 (size: 0x8)
    TSubclassOf<class UUserWidget> GhostTargetWidgetClass;                            // 0x00A0 (size: 0x8)
    TSubclassOf<class UUserWidget> TrackedTargetWidgetClass;                          // 0x00A8 (size: 0x8)
    FName PinContainerName;                                                           // 0x00B0 (size: 0x8)
    double DeathDisplayTime;                                                          // 0x00B8 (size: 0x8)
    TWeakObjectPtr<class ULocalPlayer> WeakLocalPlayerReference;                      // 0x01A0 (size: 0x8)

    void SetTrackedTargetWidgetClass(TSubclassOf<class UUserWidget> WidgetClass);
    void SetTrackedTarget(FBlamTrackedTarget TrackedTarget);
    void SetScriptedNavpoints(const TArray<FBlamScriptedNavpoint>& ScriptedNavpoints);
    void SetPriorityWidgetClass(EBlamScriptedNavpointPriority Priority, TSubclassOf<class UUserWidget> PriorityWidgetClass);
    void SetNavpointScaling(float DistanceNear, float DistanceFar, float ScaleNear, float ScaleFar);
    void SetGhostTargetWidgetClass(TSubclassOf<class UUserWidget> WidgetClass);
    void SetGhostTarget(FBlamTargetPoint TargetPoint);
    void OnChangedPrimaryWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    TSubclassOf<class UUserWidget> GetTrackedTargetWidgetClass();
    TSubclassOf<class UUserWidget> GetGhostTargetWidgetClass();
}; // Size: 0x1B0

class UHudDataAssetNavpointsItemHighlights : public UHudDataAsset
{
    TSubclassOf<class UUserWidget> ItemNavpointWidgetClass;                           // 0x0038 (size: 0x8)

    void SetNavpointScaling(float DistanceNear, float DistanceFar, float ScaleNear, float ScaleFar);
    void ItemActorsChanged(const TArray<FOverlapResult>& Overlaps);
}; // Size: 0x60

class UHudDataAssetOutOfBounds : public UHudDataAsset
{
    FHudDataAssetOutOfBoundsChangedOutOfBoundsTimerDelegate ChangedOutOfBoundsTimerDelegate; // 0x0030 (size: 0x10)
    void IntValueChanged(int32 NewValue);
    FBlamGameEngineTimer OutOfBoundsInfo;                                             // 0x0040 (size: 0x8)

    void OnChangedOutOfBoundsTimer(int32 NewValue);
}; // Size: 0x48

class UHudDataAssetPlayerRespawn : public UHudDataAsset
{
    FHudDataAssetPlayerRespawnChangedPlayerRespawnFailureDelegate ChangedPlayerRespawnFailureDelegate; // 0x0030 (size: 0x10)
    void ChangedPlayerRespawnFailure(EBlamPlayerRespawnFailure NewValue);
    FHudDataAssetPlayerRespawnChangedPlayerRespawnTimerDelegate ChangedPlayerRespawnTimerDelegate; // 0x0040 (size: 0x10)
    void IntValueChanged(int32 NewValue);
    FHudDataAssetPlayerRespawnChangedPlayerRespawnViewedPlayerDelegate ChangedPlayerRespawnViewedPlayerDelegate; // 0x0050 (size: 0x10)
    void ChangedPlayerRespawnViewedPlayer(const class APlayerState* NewValue);
    FBlamPlayerRespawn PlayerRespawnInfo;                                             // 0x0060 (size: 0xC)

    void OnChangedPlayerRespawnViewedPlayer(const class APlayerState* NewValue);
    void OnChangedPlayerRespawnTimer(int32 NewValue);
    void OnChangedPlayerRespawnFailure(EBlamPlayerRespawnFailure NewValue);
}; // Size: 0x70

class UHudDataAssetReticle : public UHudDataAsset
{
    FHudDataAssetReticleChangedUnitDelegate ChangedUnitDelegate;                      // 0x0038 (size: 0x10)
    void ChangedUnit(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    FHudDataAssetReticleChangedWeaponDelegate ChangedWeaponDelegate;                  // 0x0048 (size: 0x10)
    void ChangedWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    FHudDataAssetReticleZoomLevelChangedDelegate ZoomLevelChangedDelegate;            // 0x0058 (size: 0x10)
    void OnZoomLevelChanged_BP(int32 PreviousZoomLevel, int32 NewZoomLevel, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetReticleRoundsLoadedChangedDelegate RoundsLoadedChangedDelegate;      // 0x0068 (size: 0x10)
    void OnRoundsChanged_BP(EBlamWeaponMagazine MagazineIndex, int32 DeltaRounds, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetReticleHeatChangedDelegate HeatChangedDelegate;                      // 0x0078 (size: 0x10)
    void OnHeatChanged_BP(float DeltaHeat, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetReticleBatteryChangedDelegate BatteryChangedDelegate;                // 0x0088 (size: 0x10)
    void OnBatteryChanged_BP(float DeltaBattery, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetReticleDamageDealtDelegate DamageDealtDelegate;                      // 0x0098 (size: 0x10)
    void OnDamageAftermath(const FBlamDamageAftermathResult& DamageAftermathResult);
    FHudDataAssetReticleChangedErrorConeDelegate ChangedErrorConeDelegate;            // 0x00A8 (size: 0x10)
    void ChangedErrorCone(float ErrorRatio, float ErrorConeRadiusSlateUnits, float MinConeRadiusSlateUnits, float MaxConeRadiusSlateUnits);
    FHudDataAssetReticleChangedAimAssistConeDelegate ChangedAimAssistConeDelegate;    // 0x00B8 (size: 0x10)
    void ChangedAimAssistCone(float AimAssistConeRadiusSlateUnits);
    FHudDataAssetReticleOnChargeChangedDelegate OnChargeChangedDelegate;              // 0x00C8 (size: 0x10)
    void OnChargeChanged(EBlamWeaponTrigger TriggerIndex, float DeltaChargedFraction);
    FHudDataAssetReticleOnOverheatChangedDelegate OnOverheatChangedDelegate;          // 0x00D8 (size: 0x10)
    void OnOverheatChanged(float DeltaOverheated);
    FHudDataAssetReticleOnRecoveryPercentageChangedDelegate OnRecoveryPercentageChangedDelegate; // 0x00E8 (size: 0x10)
    void OnRecoveryPercentageChanged_BP(EBlamWeaponBarrel BarrelIndex, float DeltaRecoveryPercentage, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetReticleChangedAimAssistTargetDelegate ChangedAimAssistTargetDelegate; // 0x00F8 (size: 0x10)
    void ChangedActor(class AActor* NewActor, class AActor* PreviousActor);
    FHudDataAssetReticleChangedHeadshotStateDelegate ChangedHeadshotStateDelegate;    // 0x0108 (size: 0x10)
    void BoolValueChanged(bool NewValue);
    FHudDataAssetReticleGhostTargetChangedDelegate GhostTargetChangedDelegate;        // 0x0118 (size: 0x10)
    void BlamTargetPointChanged(FBlamTargetPoint NewValue);
    FHudDataAssetReticleOnCameraRotationChangedDelegate OnCameraRotationChangedDelegate; // 0x0128 (size: 0x10)
    void OnCameraRotationChanged(float PitchDegrees, float YawDegrees);
    float ErrorRatio;                                                                 // 0x0138 (size: 0x4)
    float ErrorConeRadiusSlateUnits;                                                  // 0x013C (size: 0x4)
    float MinConeRadiusSlateUnits;                                                    // 0x0140 (size: 0x4)
    float MaxConeRadiusSlateUnits;                                                    // 0x0144 (size: 0x4)
    float AimAssistConeRadiusSlateUnits;                                              // 0x0148 (size: 0x4)
    float CameraPitchDegrees;                                                         // 0x014C (size: 0x4)
    float CameraYawDegrees;                                                           // 0x0150 (size: 0x4)
    TWeakObjectPtr<class ULocalPlayer> WeakLocalPlayerReference;                      // 0x0154 (size: 0x8)

    void OnOverheatChanged__DelegateSignature(float DeltaOverheated);
    void OnGhostTargetChanged(FBlamTargetPoint TargetPoint);
    void OnDamageDealt(const FBlamDamageAftermathResult& DamageAftermathResult);
    void OnControlledUnitChanged(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    void OnChargeChanged__DelegateSignature(EBlamWeaponTrigger TriggerIndex, float DeltaChargedFraction);
    void OnChangedPrimaryWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    void OnChangedHeadshotState(bool bNewValue);
    void OnChangedAimAssistTarget(class AActor* NewActor, class AActor* PreviousActor);
    void OnCameraRotationChanged__DelegateSignature(float PitchDegrees, float YawDegrees);
    void ChangedErrorCone__DelegateSignature(float ErrorRatio, float ErrorConeRadiusSlateUnits, float MinConeRadiusSlateUnits, float MaxConeRadiusSlateUnits);
    void ChangedAimAssistCone__DelegateSignature(float AimAssistConeRadiusSlateUnits);
    void BlamTargetPointChanged__DelegateSignature(FBlamTargetPoint NewValue);
}; // Size: 0x160

class UHudDataAssetVehicle : public UHudDataAsset
{
    FHudDataAssetVehicleChangedVehicleDelegate ChangedVehicleDelegate;                // 0x0030 (size: 0x10)
    void ChangedVehicle(const class UBlamVehicleComponent* NewVehicle, const class UBlamVehicleComponent* PreviousVehicle);
    FHudDataAssetVehicleChangedVehicleUnitDelegate ChangedVehicleUnitDelegate;        // 0x0040 (size: 0x10)
    void ChangedUnit(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    FHudDataAssetVehicleBoostPowerChangedDelegate BoostPowerChangedDelegate;          // 0x0050 (size: 0x10)
    void OnBoostPowerChanged_BP(float BoostPower, float BoostPowerDelta, EBlamPropertyChangeReason BlamPropertyChangeReason);

    void OnChangedVehicleUnit(const class UBlamUnitComponent* NewVehicleUnit, const class UBlamUnitComponent* PreviousVehicleUnit);
    void OnChangedVehicle(const class UBlamVehicleComponent* NewVehicle, const class UBlamVehicleComponent* PreviousVehicle);
}; // Size: 0x60

class UHudDataAssetVitalityMeters : public UHudDataAsset
{
    FHudDataAssetVitalityMetersChangedUnitDelegate ChangedUnitDelegate;               // 0x0038 (size: 0x10)
    void ChangedUnit(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    FHudDataAssetVitalityMetersOnBodyDamagedDelegate OnBodyDamagedDelegate;           // 0x0048 (size: 0x10)
    void OnDamaged(float DeltaDamage);
    FHudDataAssetVitalityMetersOnShieldDamagedDelegate OnShieldDamagedDelegate;       // 0x0058 (size: 0x10)
    void OnDamaged(float DeltaDamage);
    FHudDataAssetVitalityMetersOnShieldDepletedDelegate OnShieldDepletedDelegate;     // 0x0068 (size: 0x10)
    void OnShieldDepleted();
    FHudDataAssetVitalityMetersOnShieldRechargeBeganDelegate OnShieldRechargeBeganDelegate; // 0x0078 (size: 0x10)
    void OnRechargeBegan();
    FHudDataAssetVitalityMetersOnShieldRechargeCompletedDelegate OnShieldRechargeCompletedDelegate; // 0x0088 (size: 0x10)
    void OnRechargeCompleted();
    FHudDataAssetVitalityMetersOnBodyRechargeBeganDelegate OnBodyRechargeBeganDelegate; // 0x0098 (size: 0x10)
    void OnRechargeBegan();
    FHudDataAssetVitalityMetersOnBodyRechargeCompletedDelegate OnBodyRechargeCompletedDelegate; // 0x00A8 (size: 0x10)
    void OnRechargeCompleted();
    FHudDataAssetVitalityMetersOnPlayerDeadDelegate OnPlayerDeadDelegate;             // 0x00B8 (size: 0x10)
    void OnDead();
    FHudDataAssetVitalityMetersOnRecentBodyDamageChangedDelegate OnRecentBodyDamageChangedDelegate; // 0x00C8 (size: 0x10)
    void OnRecentDamage(float RecentDamage);
    FHudDataAssetVitalityMetersOnRecentShieldDamageChangedDelegate OnRecentShieldDamageChangedDelegate; // 0x00D8 (size: 0x10)
    void OnRecentDamage(float RecentDamage);
    FHudDataAssetVitalityMetersOnUpdateVitalityMetersDelegate OnUpdateVitalityMetersDelegate; // 0x00E8 (size: 0x10)
    void UpdateVitalityMeters();
    float RecentBodyDamageFalloffDelay;                                               // 0x00F8 (size: 0x4)
    float RecentBodyDamageFalloffTime;                                                // 0x00FC (size: 0x4)
    float RecentShieldDamageFalloffDelay;                                             // 0x0100 (size: 0x4)
    float RecentShieldDamageFalloffTime;                                              // 0x0104 (size: 0x4)
    float RecentBodyDamage;                                                           // 0x0108 (size: 0x4)
    float RecentShieldDamage;                                                         // 0x010C (size: 0x4)
    class UBlamObjectDamageComponent* DamageComponentRef;                             // 0x0130 (size: 0x8)
    TWeakObjectPtr<class ULocalPlayer> WeakLocalPlayerReference;                      // 0x0138 (size: 0x8)

    void UpdateVitalityMeters__DelegateSignature();
    void OnUnitChanged(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    void OnShieldRechargeCompleted(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnShieldRechargeBegan(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnShieldDepleted__DelegateSignature();
    void OnShieldDepleted();
    void OnShieldDamaged(float DeltaDamage);
    void OnRechargeCompleted__DelegateSignature();
    void OnRechargeBegan__DelegateSignature();
    void OnRecentShieldDamageChanged(float DeltaDamage);
    void OnRecentDamage__DelegateSignature(float RecentDamage);
    void OnRecentBodyDamageChanged(float RecentDamage);
    void OnDead__DelegateSignature();
    void OnDead(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnDamaged__DelegateSignature(float DeltaDamage);
    void OnBodyRechargeCompleted(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnBodyRechargeBegan(EBlamPropertyChangeReason BlamPropertyChangeReason);
    void OnBodyDamaged(float DeltaDamage);
}; // Size: 0x140

class UHudDataAssetWeaponCradle : public UHudDataAsset
{
    FHudDataAssetWeaponCradleChangedInventoryDelegate ChangedInventoryDelegate;       // 0x0030 (size: 0x10)
    void ChangedInventory(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    FHudDataAssetWeaponCradleChangedPrimaryWeaponDelegate ChangedPrimaryWeaponDelegate; // 0x0040 (size: 0x10)
    void ChangedWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    FHudDataAssetWeaponCradleChangedBackpackWeaponDelegate ChangedBackpackWeaponDelegate; // 0x0050 (size: 0x10)
    void ChangedWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    FHudDataAssetWeaponCradleRoundsLoadedChangedDelegate RoundsLoadedChangedDelegate; // 0x0060 (size: 0x10)
    void OnRoundsChanged_BP(EBlamWeaponMagazine MagazineIndex, int32 DeltaRounds, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetWeaponCradleRoundsInventoryChangedDelegate RoundsInventoryChangedDelegate; // 0x0070 (size: 0x10)
    void OnRoundsInventoryChanged_BP(EBlamWeaponMagazine MagazineIndex, int32 DeltaRounds, EBlamPropertyChangeReason BlamPropertyChangeReason, bool IsInitialized);
    FHudDataAssetWeaponCradleBackpackRoundsInventoryChangedDelegate BackpackRoundsInventoryChangedDelegate; // 0x0080 (size: 0x10)
    void OnRoundsInventoryChanged_BP(EBlamWeaponMagazine MagazineIndex, int32 DeltaRounds, EBlamPropertyChangeReason BlamPropertyChangeReason, bool IsInitialized);
    FHudDataAssetWeaponCradleHeatChangedDelegate HeatChangedDelegate;                 // 0x0090 (size: 0x10)
    void OnHeatChanged_BP(float DeltaHeat, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetWeaponCradleBatteryChangedDelegate BatteryChangedDelegate;           // 0x00A0 (size: 0x10)
    void OnBatteryChanged_BP(float DeltaBattery, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetWeaponCradleOnRecoveryPercentageChangedDelegate OnRecoveryPercentageChangedDelegate; // 0x00B0 (size: 0x10)
    void OnRecoveryPercentageChanged_BP(EBlamWeaponBarrel BarrelIndex, float DeltaRecoveryPercentage, EBlamPropertyChangeReason BlamPropertyChangeReason);
    FHudDataAssetWeaponCradleWeaponSwap WeaponSwap;                                   // 0x00C0 (size: 0x10)
    void WeaponSwap();
    FHudDataAssetWeaponCradleWeaponPickedUp WeaponPickedUp;                           // 0x00D0 (size: 0x10)
    void WeaponPickedUp();
    FHudDataAssetWeaponCradleWeaponDropped WeaponDropped;                             // 0x00E0 (size: 0x10)
    void WeaponDropped();
    FHudDataAssetWeaponCradleWeaponAllRemoved WeaponAllRemoved;                       // 0x00F0 (size: 0x10)
    void WeaponAllRemoved();

    void WeaponSwap__DelegateSignature();
    void WeaponPickedUp__DelegateSignature();
    void WeaponDropped__DelegateSignature();
    void WeaponAllRemoved__DelegateSignature();
    void OnWeaponSetChanged(const class UBlamWeaponComponent* NewPrimaryWeapon, const class UBlamWeaponComponent* PreviousPrimaryWeapon, const class UBlamWeaponComponent* NewBackpackWeapon, const class UBlamWeaponComponent* PreviousBackpackWeapon);
    void OnInventoryChanged(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    void OnChangedPrimaryWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    void OnChangedBackpackWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
}; // Size: 0x110

class UHudDataSubsystem : public ULocalPlayerSubsystem
{
    FHudDataSubsystemChangedUnit ChangedUnit;                                         // 0x0038 (size: 0x10)
    void ChangedUnit(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    FHudDataSubsystemChangedControlledUnit ChangedControlledUnit;                     // 0x0048 (size: 0x10)
    void ChangedUnit(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    FHudDataSubsystemChangedInventory ChangedInventory;                               // 0x0058 (size: 0x10)
    void ChangedInventory(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    FHudDataSubsystemChangedVehicle ChangedVehicle;                                   // 0x0068 (size: 0x10)
    void ChangedVehicle(const class UBlamVehicleComponent* NewVehicle, const class UBlamVehicleComponent* PreviousVehicle);
    FHudDataSubsystemChangedPrimaryWeapon ChangedPrimaryWeapon;                       // 0x0078 (size: 0x10)
    void ChangedWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    FHudDataSubsystemChangedBackpackWeapon ChangedBackpackWeapon;                     // 0x0088 (size: 0x10)
    void ChangedWeapon(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    FHudDataSubsystemChangedWeaponSet ChangedWeaponSet;                               // 0x0098 (size: 0x10)
    void ChangedWeaponSet(const class UBlamWeaponComponent* NewPrimaryWeapon, const class UBlamWeaponComponent* PreviousPrimaryWeapon, const class UBlamWeaponComponent* NewBackpackWeapon, const class UBlamWeaponComponent* PreviousBackpackWeapon);
    FHudDataSubsystemChangedEquipment ChangedEquipment;                               // 0x00A8 (size: 0x10)
    void ChangedEquipment(const class UBlamEquipmentComponent* NewEquipment, const class UBlamEquipmentComponent* PreviousEquipment);
    FHudDataSubsystemChangedFadeColor ChangedFadeColor;                               // 0x00B8 (size: 0x10)
    void FadeColorChanged(FLinearColor NewValue);
    FHudDataSubsystemChangedFadeOpacity ChangedFadeOpacity;                           // 0x00C8 (size: 0x10)
    void FadeOpacityChanged(float NewValue);
    FHudDataSubsystemPlayerJoinedDelegate PlayerJoinedDelegate;                       // 0x00D8 (size: 0x10)
    void PlayerNameChange(FText NewValue);
    FHudDataSubsystemPlayerLeftDelegate PlayerLeftDelegate;                           // 0x00E8 (size: 0x10)
    void PlayerNameChange(FText NewValue);
    TWeakObjectPtr<class UBlamUnitComponent> PreviousUnit;                            // 0x00F8 (size: 0x8)
    TWeakObjectPtr<class UBlamUnitComponent> PreviousControlledUnit;                  // 0x0104 (size: 0x8)
    TWeakObjectPtr<class UBlamUnitInventoryComponent> PreviousInventory;              // 0x0110 (size: 0x8)
    TWeakObjectPtr<class UBlamVehicleComponent> PreviousVehicle;                      // 0x011C (size: 0x8)
    TWeakObjectPtr<class UBlamWeaponComponent> PreviousPrimaryWeapon;                 // 0x0128 (size: 0x8)
    TWeakObjectPtr<class UBlamWeaponComponent> PreviousBackpackWeapon;                // 0x0134 (size: 0x8)
    TWeakObjectPtr<class UBlamEquipmentComponent> PreviousEquipment;                  // 0x0140 (size: 0x8)
    FLinearColor FadeColor;                                                           // 0x014C (size: 0x10)
    float FadeOpacity;                                                                // 0x015C (size: 0x4)
    TMap<int32, FPlayerNameRecord> KnownPlayerNames;                                  // 0x0160 (size: 0x50)

    void PlayerNameChange__DelegateSignature(FText NewValue);
    void FadeOpacityChanged__DelegateSignature(float NewValue);
    void FadeColorChanged__DelegateSignature(FLinearColor NewValue);
    void ChangedWeaponSet__DelegateSignature(const class UBlamWeaponComponent* NewPrimaryWeapon, const class UBlamWeaponComponent* PreviousPrimaryWeapon, const class UBlamWeaponComponent* NewBackpackWeapon, const class UBlamWeaponComponent* PreviousBackpackWeapon);
    void ChangedWeapon__DelegateSignature(const class UBlamWeaponComponent* NewWeapon, const class UBlamWeaponComponent* PreviousWeapon);
    void ChangedVehicle__DelegateSignature(const class UBlamVehicleComponent* NewVehicle, const class UBlamVehicleComponent* PreviousVehicle);
    void ChangedUnit__DelegateSignature(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    void ChangedInventory__DelegateSignature(const class UBlamUnitInventoryComponent* NewInventory, const class UBlamUnitInventoryComponent* PreviousInventory);
    void ChangedEquipment__DelegateSignature(const class UBlamEquipmentComponent* NewEquipment, const class UBlamEquipmentComponent* PreviousEquipment);
}; // Size: 0x1B0

class UHudDebugDataSubsystem : public UGameInstanceSubsystem
{

    FString GetDebugComputerName();
}; // Size: 0x38

class UHudGlobalDataSubsystem : public UBlamGameInstanceSubsystem
{
    FHudGlobalDataSubsystemObjectivesHudChangedDelegate ObjectivesHudChangedDelegate; // 0x0078 (size: 0x10)
    void ObjectivesChanged(EBlamUserInterfaceObjectiveChangeReason ChangeReason);
    FHudGlobalDataSubsystemObjectivesMenuChangedDelegate ObjectivesMenuChangedDelegate; // 0x0088 (size: 0x10)
    void ObjectivesChanged(EBlamUserInterfaceObjectiveChangeReason ChangeReason);
    FHudGlobalDataSubsystemCinematicSkipDelegate CinematicSkipDelegate;               // 0x0098 (size: 0x10)
    void BoolValueChanged(bool NewValue);
    FHudGlobalDataSubsystemCinematicCutsceneTitleDelegate CinematicCutsceneTitleDelegate; // 0x00A8 (size: 0x10)
    void Text3ValueChanged(FText NewValue, FText NewValue2, FText NewValue3, EBlamCutsceneTitleTransitionType TransitionType);
    FHudGlobalDataSubsystemGameInfoChangedDelegate GameInfoChangedDelegate;           // 0x00B8 (size: 0x10)
    void GameInfoChanged();
    FHudGlobalDataSubsystemSystemUIWasActivatedDelegate SystemUIWasActivatedDelegate; // 0x00C8 (size: 0x10)
    void SystemUIWasActivated();
    FBlamUserInterfaceObjectives ObjectivesHud;                                       // 0x00D8 (size: 0x20)
    FBlamUserInterfaceObjectives ObjectivesMenu;                                      // 0x00F8 (size: 0x20)
    FGameInfo GameInfo;                                                               // 0x0118 (size: 0x58)

    void Text3ValueChanged__DelegateSignature(FText NewValue, FText NewValue2, FText NewValue3, EBlamCutsceneTitleTransitionType TransitionType);
    void SystemUIWasActivated__DelegateSignature();
    void ObjectivesChanged__DelegateSignature(EBlamUserInterfaceObjectiveChangeReason ChangeReason);
    void GameInfoChanged__DelegateSignature();
    void BoolValueChanged__DelegateSignature(bool NewValue);
}; // Size: 0x180

class UHudItemHighlightsSubsystem : public ULocalPlayerSubsystem
{
    FHudItemHighlightsSubsystemItemActorsChangedDelegate ItemActorsChangedDelegate;   // 0x0030 (size: 0x10)
    void ItemActorsChanged(const TArray<FOverlapResult>& Overlaps);
    FHudItemHighlightsSubsystemItemHighlightsEnabledChangedDelegate ItemHighlightsEnabledChangedDelegate; // 0x0040 (size: 0x10)
    void ItemHighlightsEnabledChanged(bool bEnabled);
    bool bItemHighlightsEnabled;                                                      // 0x0050 (size: 0x1)
    class USphereComponent* CollisionSphere;                                          // 0x0068 (size: 0x8)

    void SetCollisionSphere(class USphereComponent* CollisionSphere);
    void ItemHighlightsEnabledChanged__DelegateSignature(bool bEnabled);
    void ItemActorsChanged__DelegateSignature(const TArray<FOverlapResult>& Overlaps);
}; // Size: 0x70

class UHudUserWidget : public UHaloUIUserWidget
{
    TArray<class UHudDataAsset*> HudDataAssets;                                       // 0x0358 (size: 0x10)

    void InitializeHudDataAssets();
}; // Size: 0x368

class ULevelSelectorGenerator : public UUserWidget
{

    TArray<FString> FindLevelNames();
}; // Size: 0x2E0

class ULinkedAccount : public UObject
{
    ELinkedPlatform LinkedPlatform;                                                   // 0x0028 (size: 0x1)
    FString PlatformUserId;                                                           // 0x0030 (size: 0x10)
    FString DisplayName;                                                              // 0x0040 (size: 0x10)

}; // Size: 0x50

class UMeteoriteAccountSettingsWidget : public UHaloUIActivatableWidget
{
    FText PrimaryName;                                                                // 0x0500 (size: 0x10)
    TArray<FMeteoriteAccountAlias> SecondaryNameList;                                 // 0x0510 (size: 0x10)

    void HandlePlayerDisplayNamesLoaded();
    void HandleErrorLoadingPlayerAliases(bool bErrorIsCausedByNoConnection);
}; // Size: 0x560

class UMeteoriteAutomatorComponent : public UActorComponent
{
    TWeakObjectPtr<class AMeteoritePlayerController> AttachedController;              // 0x00A8 (size: 0x8)
    int32 CurrentActionIndex;                                                         // 0x00B0 (size: 0x4)

}; // Size: 0xB8

class UMeteoriteFriendsListPage : public UHaloUIActivatableWidget
{
    FMeteoriteFriendsListPageOnFriendsListUpdatedDelegate OnFriendsListUpdatedDelegate; // 0x0500 (size: 0x10)
    void OnFriendsListUpdated();
    class UHaloUITextBlock* RosterStatusMessageTextBox;                               // 0x0510 (size: 0x8)
    class UHaloUIListView* FriendsList;                                               // 0x0518 (size: 0x8)
    FGameplayTag UILayer;                                                             // 0x0520 (size: 0x8)

    void OnFriendsListUpdated__DelegateSignature();
}; // Size: 0x550

class UMeteoriteGameInstance : public UBlamGameInstance
{

    void OnCinematicInProgress(bool bInProgress);
}; // Size: 0x260

class UMeteoriteGameUserSettings : public UBlamGameUserSettings
{
    bool ScreenReaderEnabled;                                                         // 0x0868 (size: 0x1)
    FString ScreenReaderRate;                                                         // 0x0870 (size: 0x10)
    float ScreenReaderVolume;                                                         // 0x0880 (size: 0x4)
    FMeteoriteGameUserSettingsOnScreenReaderEnabledUpdated OnScreenReaderEnabledUpdated; // 0x0888 (size: 0x10)
    void OnSettingUpdated(FName SettingName);
    FString GlobalTextSize;                                                           // 0x0898 (size: 0x10)
    FString HudTextSize;                                                              // 0x08A8 (size: 0x10)
    FString SubtitleTextSize;                                                         // 0x08B8 (size: 0x10)
    FString SplitscreenHudTextSize;                                                   // 0x08C8 (size: 0x10)
    FString VoiceChatTextSize;                                                        // 0x08D8 (size: 0x10)
    bool bSquadInvitesEnabled;                                                        // 0x08E8 (size: 0x1)
    float VolumeMaster;                                                               // 0x08EC (size: 0x4)
    float VolumeMusicGameplay;                                                        // 0x08F0 (size: 0x4)
    float VolumeMusicMenu;                                                            // 0x08F4 (size: 0x4)
    float VolumeSFXAmbient;                                                           // 0x08F8 (size: 0x4)
    float VolumeSFXGameplay;                                                          // 0x08FC (size: 0x4)
    float VolumeSFXMenu;                                                              // 0x0900 (size: 0x4)
    float VolumeVOChatter;                                                            // 0x0904 (size: 0x4)
    float VolumeVODialog;                                                             // 0x0908 (size: 0x4)
    EAudioDynamicRange DynamicRange;                                                  // 0x090C (size: 0x1)
    bool bTTSAndSTTEnabled;                                                           // 0x090D (size: 0x1)
    float VoiceChatWidgetOpacity;                                                     // 0x0910 (size: 0x4)
    float VoiceChatBackgroundOpacity;                                                 // 0x0914 (size: 0x4)
    float VoiceChatInactiveWidgetOpacity;                                             // 0x0918 (size: 0x4)
    FString VoiceChatFadeTimerSeconds;                                                // 0x0920 (size: 0x10)
    FString VoiceChatMode;                                                            // 0x0930 (size: 0x10)
    FString VoiceChatInputDeviceId;                                                   // 0x0940 (size: 0x10)
    FString VoiceChatOutputDeviceId;                                                  // 0x0950 (size: 0x10)
    float VolumeVoiceChat;                                                            // 0x0960 (size: 0x4)
    bool bCrossplay;                                                                  // 0x0964 (size: 0x1)
    EAccountFireteamSetting FireteamSettings;                                         // 0x0965 (size: 0x1)
    FString AudioLanguage;                                                            // 0x0968 (size: 0x10)
    bool bItemHighlightsEnabled;                                                      // 0x0978 (size: 0x1)

    void SetScreenReaderEnabled(bool bNewValue);
    void SaveHaloUserSettingsOperationCompleted();
    void LoadHaloUserSettingsOperationCompleted();
    bool GetSquadInvitesEnabled();
    class UMeteoriteGameUserSettings* Get(int32 UserIndex);
    void ApplySecondaryTextSizeBlueprint(FString SettingValue, FString SettingPropertyName);
    void ApplyGlobalTextSizeBlueprint();
}; // Size: 0x9C0

class UMeteoriteGameViewportClient : public UCommonGameViewportClient
{
}; // Size: 0x438

class UMeteoriteHudVisibility : public UHaloUIHudVisibility
{
    TWeakObjectPtr<class APlayerController> PlayerControllerWeak;                     // 0x00C0 (size: 0x8)

    void OnUnitChanged(const class UBlamUnitComponent* NewUnit, const class UBlamUnitComponent* PreviousUnit);
    void OnGameInfoChanged();
    void Initialize(class APlayerController* PlayerController);
}; // Size: 0xE0

class UMeteoriteInstallPSOProgressSubsystem : public UGameInstanceSubsystem
{
    bool bProgressVisible;                                                            // 0x0038 (size: 0x1)
    int64 InstallProgress;                                                            // 0x0040 (size: 0x8)
    int64 InstallTotal;                                                               // 0x0048 (size: 0x8)
    int64 PSOProgress;                                                                // 0x0050 (size: 0x8)
    int64 PSOTotal;                                                                   // 0x0058 (size: 0x8)
    bool bWaitingForBlamExperience;                                                   // 0x0060 (size: 0x1)
    FMeteoriteInstallPSOProgressSubsystemProgressVisibleChangedDelegate ProgressVisibleChangedDelegate; // 0x0068 (size: 0x10)
    void BoolValueChanged(bool NewValue);
    FMeteoriteInstallPSOProgressSubsystemInstallProgressChangedDelegate InstallProgressChangedDelegate; // 0x0078 (size: 0x10)
    void ProgressValueChanged(int64 Numerator, int64 Denominator);
    FMeteoriteInstallPSOProgressSubsystemPSOProgressChangedDelegate PSOProgressChangedDelegate; // 0x0088 (size: 0x10)
    void ProgressValueChanged(int64 Numerator, int64 Denominator);
    FMeteoriteInstallPSOProgressSubsystemInstallCompletedDelegate InstallCompletedDelegate; // 0x0098 (size: 0x10)
    void ProgressCompleted();
    FMeteoriteInstallPSOProgressSubsystemPSOCompletedDelegate PSOCompletedDelegate;   // 0x00A8 (size: 0x10)
    void ProgressCompleted();
    FMeteoriteInstallPSOProgressSubsystemWaitingForBlamExperienceChangedDelegate WaitingForBlamExperienceChangedDelegate; // 0x00B8 (size: 0x10)
    void BoolValueChanged(bool NewValue);

    void VideoSettingsWereChanged();
    void ProgressValueChanged__DelegateSignature(int64 Numerator, int64 Denominator);
    void ProgressCompleted__DelegateSignature();
    void BoolValueChanged__DelegateSignature(bool NewValue);
}; // Size: 0xF0

class UMeteoriteInviteToastInitData : public UMeteoriteToastInitData
{
    PlatformIconType OriginatingPlayerPlatformIconType;                               // 0x0048 (size: 0x1)

}; // Size: 0x58

class UMeteoriteLoadingScreenSubsystem : public UGameInstanceSubsystem
{
    FMeteoriteLoadingScreenSubsystemOnBlamPredictedTagLoadCountChanged OnBlamPredictedTagLoadCountChanged; // 0x0038 (size: 0x10)
    void OnBlamPredictedTagLoadCountChanged(int32 PredictedTagCount);
    FMeteoriteLoadingScreenSubsystemOnBlamProgressLoadTagCountChanged OnBlamProgressLoadTagCountChanged; // 0x0048 (size: 0x10)
    void OnBlamProgressLoadTagCountChanged(int32 LoadedTagCount);
    bool bUseLoadingScreen;                                                           // 0x005B (size: 0x1)
    bool bShowNonBlockingLoadScreenAfterBlockingLoad;                                 // 0x005C (size: 0x1)
    float NonBlockingLoadMinimumDisplayTime;                                          // 0x0060 (size: 0x4)
    TSoftClassPtr<UUserWidget> DefaultNonBlockingLoadScreenClass;                     // 0x0068 (size: 0x28)
    TSoftClassPtr<UUserWidget> CurrentNonBlockingLoadScreenClass;                     // 0x0090 (size: 0x28)
    TWeakObjectPtr<class UUserWidget> NonBlockingLoadScreenUWidget;                   // 0x00F0 (size: 0x8)
    int32 CachedPredictedTagCount;                                                    // 0x00FC (size: 0x4)
    int32 CachedLoadedTagCount;                                                       // 0x0100 (size: 0x4)

    void ShowNonBlockingLoadScreen();
    void SetUseLoadingScreen(const bool bValue);
    void SetShowNonBlockingLoadScreenAfterBlockingLoad(const bool bValue);
    void SetNonBlockingLoadMinimumDisplayTime(const float InValue);
    void SetDefaultNonBlockingLoadScreenClass(TSoftClassPtr<UUserWidget> InScreen);
    void SetCurrentNonBlockingLoadScreenClass(TSoftClassPtr<UUserWidget> InScreen);
    void OnBlamProgressLoadTagCountChanged__DelegateSignature(int32 LoadedTagCount);
    void OnBlamPredictedTagLoadCountChanged__DelegateSignature(int32 PredictedTagCount);
    void HideNonBlockingLoadScreen();
    bool GetUseLoadingScreen();
    bool GetShowNonBlockingLoadScreenAfterBlockingLoad();
    int32 GetNonBlockingLoadScreenRefCount();
    float GetNonBlockingLoadMinimumDisplayTime();
    TSoftClassPtr<UUserWidget> GetDefaultNonBlockingLoadScreenClass();
    TSoftClassPtr<UUserWidget> GetCurrentNonBlockingLoadScreenClass();
}; // Size: 0x118

class UMeteoriteLobbyAlertInitData : public UHaloUIAlertInitData
{
}; // Size: 0xA0

class UMeteoriteLobbyBlueprintHelpers : public UBlueprintFunctionLibrary
{

    bool IsUserInActiveGame();
    FString GetLocalPlatformType();
    void AdjustDropdownPlacementBasedOnRelativeScrollPosition(const class UHaloUISizeBox* ParentBox, const class UHaloUIActivatableWidget* DropdownWidget);
}; // Size: 0x28

class UMeteoriteLobbyNotifier : public UGameInstanceSubsystem
{
    TSoftClassPtr<UHaloUIModalPopupWidgetBase> LobbyAlertClassDefault;                // 0x0090 (size: 0x28)
    TSoftClassPtr<UHaloUIModalPopupWidgetBase> LobbyDialogClassDefault;               // 0x00B8 (size: 0x28)
    TSubclassOf<class UMeteoriteToastWidgetBase> LobbyToastClassDefault;              // 0x00E0 (size: 0x8)
    TSubclassOf<class UMeteoriteToastWidgetBase> InviteToastWidgetDefault;            // 0x00E8 (size: 0x8)
    FGameplayTag LobbyNotificationLayer;                                              // 0x00F0 (size: 0x8)
    FMeteoriteLobbyNotifierRequestCancelCountdownDelegate RequestCancelCountdownDelegate; // 0x0298 (size: 0x10)
    void RequestCancelCountdown();

    void SetXsapiLogoutAlertPending(bool Value);
    void RequestCancelCountdown__DelegateSignature();
    void InitializeLobbyWidgetInfo(TSoftClassPtr<UHaloUIModalPopupWidgetBase> InLobbyAlertDefaultClass, TSoftClassPtr<UHaloUIModalPopupWidgetBase> InLobbyDialogDefaultClass, TSubclassOf<class UMeteoriteToastWidgetBase> InLobbyToastDefaultClass, TSubclassOf<class UMeteoriteToastWidgetBase> InInviteToastWidgetDefaultClass, FGameplayTag UILayer);
    void HandleUserSettingsConflictResult(EHaloUIModalPopupResult Result, class UHaloUIPopupInitData* InitData);
    void HandleOnInputDeviceConnectionChange(EInputDeviceConnectionState NewConnectionState, FPlatformUserId PlatformUserId, FInputDeviceId InputDeviceId);
    void HandleDialogCompleted(EHaloUIModalPopupResult Result, class UHaloUIPopupInitData* PopupInitData);
    bool GetXsapiLogoutAlertPending();
    void EndAllowInvites();
    void BeginAllowInvites();
    void AcceptInvite(class UMeteoriteInviteToastInitData* ToastInitData);
}; // Size: 0x2C0

class UMeteoriteLobbyNotifierDialogInitData : public UHaloUIDialogInitData
{
}; // Size: 0xD8

class UMeteoriteLocalPlayer : public UBlamLocalPlayer
{
}; // Size: 0x2B8

class UMeteoriteMenuStateSubsystem : public UHaloUIMenuStateSubsystem
{
    FMeteoriteMenuStateSubsystemOnWindowFocusChanged OnWindowFocusChanged;            // 0x0040 (size: 0x10)
    void OnWindowFocusChanged(bool bIsFocused);
    FMeteoriteMenuStateSubsystemOnXsapiStart OnXsapiStart;                            // 0x0050 (size: 0x10)
    void OnXsapiLoginStart(FString Uri, FString Code);
    FMeteoriteMenuStateSubsystemOnXsapiEnd OnXsapiEnd;                                // 0x0060 (size: 0x10)
    void OnXsapiLoginEnd(bool bWasCanceled, FString NativeAccountString);
    FMeteoriteMenuStateSubsystemOnUnlinkAccountComplete OnUnlinkAccountComplete;      // 0x0070 (size: 0x10)
    void OnUnlinkAccountComplete(bool bSuccess, FString ErrorMessage);
    FMeteoriteMenuStateSubsystemOnLinkAccountComplete OnLinkAccountComplete;          // 0x0080 (size: 0x10)
    void OnLinkAccountComplete(bool bSuccess, FString ErrorMessage);
    FMeteoriteMenuStateSubsystemOnAccountLinkBackout OnAccountLinkBackout;            // 0x0090 (size: 0x10)
    void OnAccountLinkBackout();
    FMeteoriteMenuStateSubsystemOnLoginSucceededSimple OnLoginSucceededSimple;        // 0x00A0 (size: 0x10)
    void OnLoginSucceededMulticast();
    FMeteoriteMenuStateSubsystemOnLoginFailedSimple OnLoginFailedSimple;              // 0x00B0 (size: 0x10)
    void OnLoginFailedMulticast(FString FailureReason);
    FMeteoriteMenuStateSubsystemStartButtonReleasedRequest StartButtonReleasedRequest; // 0x00C0 (size: 0x10)
    void OnStartButtonReleasedRequest(FKeyEvent KeyEvent);
    FMeteoriteMenuStateSubsystemOnLoginSucceeded OnLoginSucceeded;                    // 0x00D0 (size: 0x10)
    void OnLoginSucceeded();
    FMeteoriteMenuStateSubsystemOnLoginFailed OnLoginFailed;                          // 0x00E0 (size: 0x10)
    void OnLoginFailed(FString FailureReason);

    void UnlinkAndLogout(class ULocalPlayer* LocalUser);
    void StartSplitScreenLogin(int32 LocalUserIndex, FStartSplitScreenLoginOnLoginSucceeded OnLoginSucceeded, FStartSplitScreenLoginOnLoginFailed OnLoginFailed);
    void StartLogin(int32 LocalUserIndex, FStartLoginOnLoginSucceeded OnLoginSucceeded, FStartLoginOnLoginFailed OnLoginFailed);
    bool ResolveDisplayNames(class ULocalPlayer* LocalUser, FText& OutPlatformDisplayName, FText& OutLinkedAccountDisplayName);
    void RequestMainMenu();
    void OnXsapiLoginStart__DelegateSignature(FString Uri, FString Code);
    void OnXsapiLoginEnd__DelegateSignature(bool bWasCanceled, FString NativeAccountString);
    void OnWindowFocusChanged__DelegateSignature(bool bIsFocused);
    void OnUnlinkAccountComplete__DelegateSignature(bool bSuccess, FString ErrorMessage);
    void OnStartButtonReleasedRequest__DelegateSignature(FKeyEvent KeyEvent);
    void OnLoginSucceededMulticast__DelegateSignature();
    void OnLoginSucceeded__DelegateSignature();
    void OnLoginFailedMulticast__DelegateSignature(FString FailureReason);
    void OnLoginFailed__DelegateSignature(FString FailureReason);
    void OnLinkAccountComplete__DelegateSignature(bool bSuccess, FString ErrorMessage);
    void OnAccountLinkBackout__DelegateSignature();
    void MsaLogout(class ULocalPlayer* LocalUser);
    void Logout(class ULocalPlayer* LocalUser);
    bool LoadSettingsAfterLogin();
    void LinkAccount(class ULocalPlayer* LocalUser);
    bool IsPrimaryUserFullySignedInAndLinked();
    void HandleAccountLinkBackout();
    FString GetAccountMsaSignInURLCode();
    FString GetAccountMsaSignInURI();
    FDateTime GetAccountMsaSignInCodeExpireTime();
    FString GetAccountLinkingURLCode();
    FString GetAccountLinkingURI();
    void CancelLogin(class ULocalPlayer* LocalUser);
    bool AccountMsaSignInForLinking();
}; // Size: 0x1A8

class UMeteoriteMotionTrackerPlayerDataSubsystem : public ULocalPlayerSubsystem
{
    FMeteoriteMotionTrackerPlayerDataSubsystemChangedPlayerRemainingLifetimeDelegate ChangedPlayerRemainingLifetimeDelegate; // 0x0038 (size: 0x10)
    void FloatValueChanged(float NewValue);
    FMeteoriteMotionTrackerPlayerDataSubsystemChangedPlayerCompassYawDelegate ChangedPlayerCompassYawDelegate; // 0x0048 (size: 0x10)
    void FloatValueChanged(float NewValue);
    class UHaloUIMotionTrackerDataWrapper* MotionTrackerDataWrapper;                  // 0x0108 (size: 0x8)

    void SetVisibleSpeed(float VisibleSpeed);
    void SetVisibleRange(float Value);
    void SetVerticalDistanceThreshold(float Value);
    void SetVerticalCutoffDistance(float Value);
    void SetSelfActor(class AActor* SelfActor);
    void SetPlayerSneakSpeed(float PlayerSneakSpeed);
    void SetLargeActorType(TSubclassOf<class AActor> LargeActorType);
    void SetLargeActorScale(float LargeActorScale);
    void SetDetectionRange(float Value);
    void SetBlipSize(float Value);
    void SetBlipLifetime(float Value);
    void SetBelowDistance(float Value);
    void SetAboveDistance(float Value);
    float GetPlayerRemainingLifetime();
    float GetPlayerCompassYaw();
    class UHaloUIMotionTrackerDataWrapper* GetMotionTrackerData();
    void FloatValueChanged__DelegateSignature(float NewValue);
}; // Size: 0x110

class UMeteoriteMotionTrackerSharedDataSubsystem : public UWorldSubsystem
{

    void UntrackActor(class AActor* Actor);
    void TrackActor(class AActor* Actor);
}; // Size: 0x48

class UMeteoriteNavigationSystem : public UNavigationSystemV1
{
}; // Size: 0x1660

class UMeteoritePlayerViewModel : public UObject
{
    FPlatformUserId PlatformUserId;                                                   // 0x0040 (size: 0x4)
    FString DisplayName;                                                              // 0x0048 (size: 0x10)
    bool bIsLeader;                                                                   // 0x0058 (size: 0x1)
    ERosterFriendPlatformType PlatformType;                                           // 0x0059 (size: 0x1)
    class APlayerController* PlayerController;                                        // 0x0060 (size: 0x8)
    class APlayerState* PlayerState;                                                  // 0x0068 (size: 0x8)
    bool bIsMuted;                                                                    // 0x0070 (size: 0x1)
    FMeteoritePlayerViewModelMuteStateChangedDelegate MuteStateChangedDelegate;       // 0x0078 (size: 0x10)
    void OnMuteStateChanged(class UMeteoritePlayerViewModel* ViewModel, bool bNowMuted);

    void ViewProfile();
    void ToggleMute();
    void RefreshMuteState();
    void PromoteToLeader();
    void OnMuteStateChanged__DelegateSignature(class UMeteoritePlayerViewModel* ViewModel, bool bNowMuted);
    void LeaveFireteam();
    void KickFromFireteam();
    bool IsTalking();
    bool IsMuted();
    bool IsInGameplayState();
    bool CanViewProfile();
    bool CanToggleMute();
    bool CanPromoteToLeader();
    bool CanLeaveFireteam();
    bool CanKickFromFireteam();
}; // Size: 0x88

class UMeteoritePresenceWorldSubsystem : public UWorldSubsystem
{
}; // Size: 0x30

class UMeteoriteProfilePuckBase : public UHaloUIViewButtonBase
{
    TSoftClassPtr<UMeteoriteProfileTrayWidgetBase> ProfileTrayClass;                  // 0x1578 (size: 0x28)
    class URosterFriendItemData* PlayerData;                                          // 0x15A0 (size: 0x8)

    void SetProfileLink(class URosterFriendItemData* NewPlayerData);
    void JoinOtherPlayer();
    void InviteOtherPlayer();
    FText GetPresence();
    FText GetNickname();
    FText GetDisplayName();
    class UMeteoriteProfileTrayWidgetBase* GenerateProfileTrayForPlayer();
}; // Size: 0x15B0

class UMeteoriteProfileTrayWidgetBase : public UHaloUIActivatableWidget
{
    FMeteoriteProfileTrayWidgetBaseCanShowJoinFriendUpdatedDelegate CanShowJoinFriendUpdatedDelegate; // 0x0500 (size: 0x10)
    void CanShowJoinFriendUpdated();
    class UHaloUIRichTextBlock* ActiveDisplayNameTextBlock;                           // 0x0510 (size: 0x8)
    class UHaloUIStackBox* AlternateDisplayNameList;                                  // 0x0518 (size: 0x8)
    TSoftClassPtr<UHaloUIModalPopupWidgetBase> AlertClass;                            // 0x0520 (size: 0x28)
    FGameplayTag UILayer;                                                             // 0x0548 (size: 0x8)
    class UMeteoriteRosterWidgetBase* RosterWidget;                                   // 0x0550 (size: 0x8)
    class URosterFriendItemData* PlayerInfo;                                          // 0x0558 (size: 0x8)

    void ToggleMute();
    void RequestUpdateForCanJoinFriend();
    void RemoveFriend();
    void RedirectPlayerToOSSProfile();
    void JoinFriend();
    bool IsPlayerOnline();
    void InviteFriend();
    void HandlePlayerLinkEstablished();
    void HandleAlternativeNameListLoaded_BP(const TArray<FText>& AlternateNameList);
    FText GetPlayerStatus();
    void DebugSetAlertClass(TSoftClassPtr<UHaloUIModalPopupWidgetBase> AlertDefaultClass, FGameplayTag UILayerSelection);
    bool CanShowRemoveFriend();
    bool CanShowRedirectPlayerToOSSProfile();
    void CanShowJoinFriendUpdated__DelegateSignature();
    ERosterJoinability CanShowJoinFriend();
    bool CanShowInviteFriend();
}; // Size: 0x568

class UMeteoriteRosterViewModel : public ULocalPlayerSubsystem
{
    FMeteoriteRosterViewModelOnRosterConnectivityChanged OnRosterConnectivityChanged; // 0x0038 (size: 0x10)
    void OnRosterConnectivityChanged(bool IsOffline);
    class UMeteoriteRosterWidgetBase* ActiveRosterWidget;                             // 0x0050 (size: 0x8)
    class UMeteoriteProfileTrayWidgetBase* ActiveProfileTrayWidget;                   // 0x0058 (size: 0x8)

    void OnRosterConnectivityChanged__DelegateSignature(bool IsOffline);
    bool IsAnyFriendJoinable(FPlatformUserId PlatformUserId);
    bool GetRosterOfflineModeEnabled();
}; // Size: 0x100

class UMeteoriteRosterWidgetBase : public UHaloUIActivatableWidget
{
    class UHaloUINavBarWidget* FriendsListNavBar;                                     // 0x0500 (size: 0x8)
    class UCommonActivatableWidgetSwitcher* FriendsListPageSwitcher;                  // 0x0508 (size: 0x8)
    TSoftClassPtr<UMeteoriteProfilePuckBase> DefaultPuckClass;                        // 0x0510 (size: 0x28)
    FGameplayTag UILayer;                                                             // 0x0538 (size: 0x8)
    FText OfflineMessage;                                                             // 0x0540 (size: 0x10)
    FText EmptyFriendsListMessage;                                                    // 0x0550 (size: 0x10)
    FText NoCrossplayFriendsListMessage;                                              // 0x0560 (size: 0x10)
    class UMeteoriteRosterViewModel* ViewModelPtr;                                    // 0x0580 (size: 0x8)
    TArray<class UMeteoriteFriendsListPage*> PageList;                                // 0x0588 (size: 0x10)

}; // Size: 0x598

class UMeteoriteSettingsConfig : public UDeveloperSettings
{
    TMap<class FName, class FSoftObjectPath> NamedRtpcs;                              // 0x0038 (size: 0x50)
    TMap<class EAudioDynamicRange, class FSoftObjectPath> DynamicRangeEvents;         // 0x0088 (size: 0x50)
    TSoftObjectPtr<UDataTable> AlertsTable;                                           // 0x00D8 (size: 0x28)
    TSoftClassPtr<UHaloUIModalPopupWidgetBase> AlertWidgetClass;                      // 0x0100 (size: 0x28)
    TSoftObjectPtr<UDataTable> InProgressTable;                                       // 0x0128 (size: 0x28)
    TSoftClassPtr<UHaloUIModalPopupWidgetBase> InProgressWidgetClass;                 // 0x0150 (size: 0x28)
    TSoftObjectPtr<UDataTable> EntitlementsTable;                                     // 0x0178 (size: 0x28)
    TSoftObjectPtr<UTexture2D> BlockingLoadScreenFlipbookTexture;                     // 0x01A0 (size: 0x28)
    FMargin BlockingLoadScreenFlipbookMargin;                                         // 0x01C8 (size: 0x10)
    float BlockingLoadScreenFlipbookTime;                                             // 0x01D8 (size: 0x4)
    FLinearColor BlockingLoadScreenBGColor;                                           // 0x01DC (size: 0x10)
    FTimespan MicrosoftAccountLoginExpireTime;                                        // 0x01F0 (size: 0x8)
    TArray<FScreenReaderRate> ScreenReaderRates;                                      // 0x01F8 (size: 0x10)
    TArray<FVoiceChatFadeTimerSeconds> FadeTimerSeconds;                              // 0x0208 (size: 0x10)

    float GetScreenReaderRateForString(FString RateString);
    float GetScreenReaderRateForGameplayTag(const FGameplayTag& RateTag);
    FTimespan GetMicrosoftAccountLoginExpireTime();
    float GetFadeTimerSecondsForString(FString TimerString);
    float GetFadeTimerSecondsForGameplayTag(const FGameplayTag& TimerTag);
}; // Size: 0x218

class UMeteoriteShowLoginUICallbackProxy : public UBlueprintAsyncActionBase
{
    FMeteoriteShowLoginUICallbackProxyOnSuccess onSuccess;                            // 0x0030 (size: 0x10)
    void MeteoriteOnShowLoginUISuccess(int32 LocalUserNum, FString UniqueNetIdStr);
    FMeteoriteShowLoginUICallbackProxyOnFailure onFailure;                            // 0x0040 (size: 0x10)
    void MeteoriteOnShowLoginUIFailure(int32 LocalUserNum);
    class UObject* WorldContextObject;                                                // 0x0050 (size: 0x8)

    class UMeteoriteShowLoginUICallbackProxy* ShowExternalLoginUI(class UObject* WorldContextObject, int32 ControllerIndex);
}; // Size: 0x90

class UMeteoriteSocialCacheSubsystem : public UGameInstanceSubsystem
{
}; // Size: 0x80

class UMeteoriteSquadLobbyViewItemData : public UHaloUIViewItemData
{
    EMeteoriteSquadLobbyRowType FireteamRowType;                                      // 0x0100 (size: 0x1)
    class UMeteoritePlayerViewModel* PlayerViewModel;                                 // 0x0108 (size: 0x8)
    FMeteoriteSquadLobbyViewItemDataBackingDataChangedDelegate BackingDataChangedDelegate; // 0x0110 (size: 0x10)
    void BackingDataChanged(class UMeteoriteSquadLobbyViewItemData* Item);
    FMeteoriteSquadLobbyViewItemDataTalkingStateChangedDelegate TalkingStateChangedDelegate; // 0x0120 (size: 0x10)
    void OnTalkingStateChanged(class UMeteoriteSquadLobbyViewItemData* Item, bool bIsTalking);
    FMeteoriteSquadLobbyViewItemDataVoiceStateChangedDelegate VoiceStateChangedDelegate; // 0x0130 (size: 0x10)
    void OnVoiceStateChanged(class UMeteoriteSquadLobbyViewItemData* Item, EVoiceParticipantIconState NewState);
    EVoiceParticipantIconState VoiceIconState;                                        // 0x0140 (size: 0x1)
    class UMeteoritePlayerViewModel* MuteDelegateBoundPlayerViewModel;                // 0x0150 (size: 0x8)

    void OnVoiceStateChanged__DelegateSignature(class UMeteoriteSquadLobbyViewItemData* Item, EVoiceParticipantIconState NewState);
    void OnTalkingStateChanged__DelegateSignature(class UMeteoriteSquadLobbyViewItemData* Item, bool bIsTalking);
    void HandleMuteStateChanged(class UMeteoritePlayerViewModel* InViewModel, bool bNowMuted);
    void BackingDataChanged__DelegateSignature(class UMeteoriteSquadLobbyViewItemData* Item);
}; // Size: 0x160

class UMeteoriteSquadLobbyViewModel : public UGameInstanceSubsystem
{
    TSubclassOf<class UUserWidget> PlayerWidgetClass;                                 // 0x0038 (size: 0x8)
    TSubclassOf<class UUserWidget> SplitscreenWidgetClass;                            // 0x0040 (size: 0x8)
    TSubclassOf<class UUserWidget> BlankWidgetClass;                                  // 0x0048 (size: 0x8)
    bool bOfferJoinSlots;                                                             // 0x0050 (size: 0x1)
    TArray<class UMeteoriteSquadLobbyViewItemData*> SquadMembers;                     // 0x0058 (size: 0x10)
    FMeteoriteSquadLobbyViewModelBackingDataChangedDelegate BackingDataChangedDelegate; // 0x0068 (size: 0x10)
    void BackingDataChanged();
    FMeteoriteSquadLobbyViewModelCrossplayEnabledChangedDelegate CrossplayEnabledChangedDelegate; // 0x0078 (size: 0x10)
    void OnCrossplayEnabledChanged(bool bEnabled);
    FMeteoriteSquadLobbyViewModelSquadMemberTalkingStateChangedDelegate SquadMemberTalkingStateChangedDelegate; // 0x0088 (size: 0x10)
    void OnSquadMemberTalkingStateChanged(class UMeteoriteSquadLobbyViewItemData* Item, bool bIsTalking);
    FMeteoriteSquadLobbyViewModelOnSquadConnectivityChanged OnSquadConnectivityChanged; // 0x0098 (size: 0x10)
    void OnSquadConnectivityChanged(bool IsOffline);
    FMeteoriteSquadLobbyViewModelOnReconnectAttemptFailed OnReconnectAttemptFailed;   // 0x00A8 (size: 0x10)
    void OnReconnectAttemptFailed();
    FMeteoriteSquadLobbyViewModelOnSplitscreenStatusChanged OnSplitscreenStatusChanged; // 0x00B8 (size: 0x10)
    void OnSplitscreenStatusChanged(bool ShouldActivateSquadWidget);
    FMeteoriteSquadLobbyViewModelTotalPlayerCountChangedDelegate TotalPlayerCountChangedDelegate; // 0x00C8 (size: 0x10)
    void TotalPlayerCountChanged(int32 NewCount);
    int32 TotalPlayerCount;                                                           // 0x00D8 (size: 0x4)
    bool bCrossPlayEnabled;                                                           // 0x00F0 (size: 0x1)

    void TotalPlayerCountChanged__DelegateSignature(int32 NewCount);
    void SetSplitscreenWidgetClass(TSubclassOf<class UUserWidget> InClass);
    void OnSquadMemberTalkingStateChanged__DelegateSignature(class UMeteoriteSquadLobbyViewItemData* Item, bool bIsTalking);
    void OnSquadConnectivityChanged__DelegateSignature(bool IsOffline);
    void OnSplitscreenStatusChanged__DelegateSignature(bool ShouldActivateSquadWidget);
    void OnReconnectAttemptFailed__DelegateSignature();
    void OnCrossplayEnabledChanged__DelegateSignature(bool bEnabled);
    void HandleItemTalkingStateChanged(class UMeteoriteSquadLobbyViewItemData* Item, bool bIsTalking);
    void HandleInputDeviceConnectionChange(EInputDeviceConnectionState NewConnectionState, FPlatformUserId PlatformUserId, FInputDeviceId InputDeviceId);
    int32 GetNumSquadMembers();
    bool CheckIsOffline();
    bool CanAddSplitscreenPlayer();
    void BackingDataChanged__DelegateSignature();
}; // Size: 0x1A0

class UMeteoriteSquadVoiceViewItemData : public UHaloUIViewItemData
{
    class UMeteoritePlayerViewModel* PlayerViewModel;                                 // 0x0100 (size: 0x8)
    bool bHasValidPlayer;                                                             // 0x0108 (size: 0x1)

}; // Size: 0x110

class UMeteoriteSquadVoiceViewModel : public UGameInstanceSubsystem
{
    FMeteoriteSquadVoiceViewModelBackingDataChangedDelegate BackingDataChangedDelegate; // 0x0038 (size: 0x10)
    void BackingDataChanged();
    TSubclassOf<class UUserWidget> PlayerWidgetClass;                                 // 0x0048 (size: 0x8)
    TArray<class UMeteoriteSquadVoiceViewItemData*> SquadMembers;                     // 0x0050 (size: 0x10)

    void BackingDataChanged__DelegateSignature();
}; // Size: 0x60

class UMeteoriteSquadWidgetBase : public UHaloUIActivatableWidget
{
    class UHaloUIStackBox* SquadStack;                                                // 0x0500 (size: 0x8)
    TSoftClassPtr<UHaloUIActivatableWidget> SquadPlayerComponentWidgetClass;          // 0x0508 (size: 0x28)

    void UpdateUIBySquadPlayerInfo(class UHaloUIActivatableWidget* NewSquadPlayerWidget, class APlayerController* SquadPlayerController, FText& SquadPlayerDisplayName, bool bIsSquadLeader, int32 OEPlatformIdx);
    void SetSquadPlayerComponentWidgetClass(TSoftClassPtr<UHaloUIActivatableWidget> NewClassType);
}; // Size: 0x530

class UMeteoriteTextChatWidgetBase : public UHaloUIActivatableWidget
{
    FMeteoriteTextChatWidgetBaseBP_OnChatFocusActivated BP_OnChatFocusActivated;      // 0x0500 (size: 0x10)
    void OnChatFocusActivationChanged();
    FMeteoriteTextChatWidgetBaseBP_OnChatFocusDeactivated BP_OnChatFocusDeactivated;  // 0x0510 (size: 0x10)
    void OnChatFocusActivationChanged();
    class UScrollBox* ScrollBox;                                                      // 0x0520 (size: 0x8)
    class UHaloUIVerticalBox* MessageList;                                            // 0x0528 (size: 0x8)
    class UHaloUITextEntry* InputTxt;                                                 // 0x0530 (size: 0x8)
    class UHaloUISizeBox* ChatContainer;                                              // 0x0538 (size: 0x8)
    class UHaloUIBorder* BackgroundWidget;                                            // 0x0540 (size: 0x8)
    class UHaloUIRichTextBlock* ChatDescription;                                      // 0x0548 (size: 0x8)
    class UHaloUIOverlay* FullWidget;                                                 // 0x0550 (size: 0x8)
    TSubclassOf<class UCommonTextStyle> TextStyleClass;                               // 0x0558 (size: 0x8)
    class UInputAction* SendAction;                                                   // 0x0560 (size: 0x8)
    class UInputAction* ClearAction;                                                  // 0x0568 (size: 0x8)
    bool bAutoScroll;                                                                 // 0x0570 (size: 0x1)
    float FadeTimerSeconds;                                                           // 0x0574 (size: 0x4)
    float LengthOfFadeOutTimeSeconds;                                                 // 0x0578 (size: 0x4)
    float InactiveWidgetOpacity;                                                      // 0x057C (size: 0x4)
    FLinearColor NormalTextColor;                                                     // 0x0580 (size: 0x10)
    FLinearColor PartialTranscriptionColor;                                           // 0x0590 (size: 0x10)
    FLinearColor FinalTranscriptionColor;                                             // 0x05A0 (size: 0x10)
    int32 InputFontSize;                                                              // 0x05B0 (size: 0x4)
    FLinearColor InputBackgroundColor;                                                // 0x05B4 (size: 0x10)
    FLinearColor InputBackgroundFocusedColor;                                         // 0x05C4 (size: 0x10)
    float WidthFraction;                                                              // 0x05D4 (size: 0x4)
    float HeightFraction;                                                             // 0x05D8 (size: 0x4)
    FMargin ViewportMargin;                                                           // 0x05DC (size: 0x10)
    bool bUseGlobalViewportForSizing;                                                 // 0x05EC (size: 0x1)
    int32 MinPixelWidth;                                                              // 0x05F0 (size: 0x4)
    bool bLogInitialSizingDiagnostics;                                                // 0x05F4 (size: 0x1)
    bool bBottomAnchorMessages;                                                       // 0x05F5 (size: 0x1)
    float AbsoluteWidthDebugOverride;                                                 // 0x05F8 (size: 0x4)
    bool bWrapInputInRuntimeSizeBox;                                                  // 0x05FC (size: 0x1)
    bool bCompensateForViewportDPIScale;                                              // 0x05FD (size: 0x1)
    bool bFractionsUseFullWindow;                                                     // 0x05FE (size: 0x1)
    bool bRespectDesignSurfaceAspect;                                                 // 0x05FF (size: 0x1)
    float TargetDesignSurfaceAspect;                                                  // 0x0600 (size: 0x4)
    bool bAllowMouseClickToActivate;                                                  // 0x0604 (size: 0x1)
    bool bAutoExitAfterSend;                                                          // 0x0605 (size: 0x1)
    bool bIsInteractive;                                                              // 0x0606 (size: 0x1)
    bool bForceWidgetActive;                                                          // 0x0607 (size: 0x1)
    TArray<class TSubclassOf<URichTextBlockDecorator>> DecoratorClasses;              // 0x0608 (size: 0x10)
    class UMeteoriteVoiceSubsystem* CachedVoiceSubsystem;                             // 0x0960 (size: 0x8)
    class UMeteoriteRosterViewModel* CachedRosterViewModel;                           // 0x0968 (size: 0x8)
    class UHaloUISizeBox* TopSlackSpacer;                                             // 0x0990 (size: 0x8)
    class UHaloUISizeBox* InputWidthBox;                                              // 0x0998 (size: 0x8)

    void WasManuallyScrolled();
    void ToggleChatFocus();
    void ShowChatWidget();
    void SetIsInteractive(const bool Value);
    void SetCurrentInactiveWidgetOpacity(float Value);
    void SetCurrentFullWidgetOpacity(float Value);
    void SetCurrentFadeTimerSeconds(float Value);
    void SetCurrentBackingWidgetOpacity(float Value);
    bool SendCurrentInput();
    void RefreshDisplayNamesFromRoster();
    void HideChatWidget();
    void HandleInputTextCommitted(const FText& Text, TEnumAsByte<ETextCommit::Type> CommitMethod);
    void HandleInputTextChanged(const FText& Text);
    void ForceWidgetActive(const bool Value);
    void DeactivateChatFocus();
    void ApplyVoiceChatMode(FString Value, bool bTTS, bool bSTT);
    void ActivateChatFocus();
}; // Size: 0x9C0

class UMeteoriteToastAsyncNodeBase : public UBlueprintAsyncActionBase
{
    FMeteoriteToastAsyncNodeBaseOnResult OnResult;                                    // 0x0030 (size: 0x10)
    void OnToastResult(EToastResult Result);
    class UMeteoriteToastSubsystem* ToastSystem;                                      // 0x0040 (size: 0x8)
    class UMeteoriteToastInitData* InitData;                                          // 0x0048 (size: 0x8)

    void SetToastSystemPtr(class UMeteoriteToastSubsystem* ToastSystemPtr);
    void QueueToast(FText Title, TSubclassOf<class UMeteoriteToastWidgetBase> WidgetClass, FPlatformUserId TargetPlayerPlatformId);
    void HandleToastAction(EToastResult Result);
    class UMeteoriteToastAsyncNodeBase* CreateMeteoriteToastFromInitData(class UObject* InWorldContextObject, class UMeteoriteToastInitData* InInitData);
}; // Size: 0x50

class UMeteoriteToastInitData : public UObject
{
    FText Title;                                                                      // 0x0028 (size: 0x10)
    TSubclassOf<class UMeteoriteToastWidgetBase> WidgetClass;                         // 0x0038 (size: 0x8)
    FPlatformUserId TargetPlayerPlatformId;                                           // 0x0040 (size: 0x4)

}; // Size: 0x48

class UMeteoriteToastSubsystem : public UGameInstanceSubsystem
{
    TArray<FToastAsyncNodePair> ToastQueue;                                           // 0x0038 (size: 0x10)

}; // Size: 0x50

class UMeteoriteToastWidgetBase : public UHaloUIActivatableWidget
{
    class UHaloUITextBlock* TitleTextBox;                                             // 0x0500 (size: 0x8)
    class UMeteoriteToastInitData* InitData;                                          // 0x0508 (size: 0x8)
    class UMeteoriteToastAsyncNodeBase* AsyncNode;                                    // 0x0510 (size: 0x8)

    void ToastAction(EToastResult Result);
}; // Size: 0x518

class UMeteoriteUIBlueprintLibrary : public UBlueprintFunctionLibrary
{

    bool IsInputActionACurrentlyActiveBinding(class APlayerController* PlayerController, const class UInputAction* InputAction);
    void GetPlatformImageString(const PlatformIconType Icon, FString& OutputIconString);
    void AttemptReconnection(const class UObject* WorldContextObject);
    FString AppendPlatformImageStringToGamertagFromPlayerController(class APlayerController* PlayerController, const bool bFront, FString& OutputIconGamertagString);
    FString AppendPlatformImageStringToGamertag(const PlatformIconType Icon, const bool bFront, FString& OutputIconGamertagString);
}; // Size: 0x28

class UMeteoriteUILinkedAccountsAsyncAction : public UBlueprintAsyncActionBase
{
    FMeteoriteUILinkedAccountsAsyncActionOnResult OnResult;                           // 0x0030 (size: 0x10)
    void OnMeteoriteUIGetLinkedAccounts(FGetLinkedAccountResult LinkedAccounts);
    FMeteoriteUILinkedAccountsAsyncActionOnError OnError;                             // 0x0040 (size: 0x10)
    void OnMeteoriteUIGetLinkedAccountsError();

    class UMeteoriteUILinkedAccountsAsyncAction* GetLinkedAccounts(class UObject* InWorldContextObject, class APlayerController* PlayerController);
}; // Size: 0x60

class UMeteoriteUISaveSlotCampaignUIInfoAsyncAction : public UBlueprintAsyncActionBase
{
    FMeteoriteUISaveSlotCampaignUIInfoAsyncActionOnResult OnResult;                   // 0x0030 (size: 0x10)
    void MeteoriteUISaveSlotCampaignUIInfoResultSignature(FSaveSlotCampaignUIInfo SaveSlotCampaignUIInfo);
    FMeteoriteUISaveSlotCampaignUIInfoAsyncActionOnError OnError;                     // 0x0040 (size: 0x10)
    void MeteoriteUISaveSlotCampaignUIInfoErrorSignature();

    class UMeteoriteUISaveSlotCampaignUIInfoAsyncAction* GetSaveSlotCampaignUIInfoAsync(class UObject* InWorldContextObject, class APlayerController* PlayerController, EBlamGameModeSaveSlot RequestedSaveSlot);
    class UMeteoriteUISaveSlotCampaignUIInfoAsyncAction* GetLatestSaveSlotCampaignUIInfoAsync(class UObject* InWorldContextObject, class APlayerController* PlayerController);
}; // Size: 0x80

class UMeteoriteUIStatics : public UBlueprintFunctionLibrary
{

    class APlayerController* TryAndGetLocalPlayerControllerForBlamObjectActor(class ABlamObjectActor* InBlamActor);
    void ShowStore(class APlayerController* PlayerController, FName EntitlementName);
    void SetPlatformMouseCursorEnabled(const int32 LocalUserIndex, const bool bEnabled);
    void SetEquippedObjectSkin(class APlayerController* PlayerController, FGameplayTag SkinName);
    void SetDifficultyModifiersEnabled(bool bEnabled);
    void SaveEquippedSkinSelections(class APlayerController* PlayerController, FSaveEquippedSkinSelectionsOnSaveCompleted OnSaveCompleted);
    void ResumeRemixSave(class APlayerController* PlayerController);
    void ResumeDLCSave(class APlayerController* PlayerController);
    void ResumeCampaignSave(class APlayerController* PlayerController);
    void RequestWaypointEntitlements(class APlayerController* PlayerController);
    bool IsWaypointEntitlement(class UObject* WorldContextObject, FName EntitlementName);
    bool IsShippingBuild();
    bool IsReadyForGameplay(class APlayerState* PlayerState);
    bool IsPurchasableEntitlement(class UObject* WorldContextObject, FName EntitlementName);
    bool IsProgressionGameplayTagPresent(class APlayerController* PlayerController, FGameplayTag ProgressionTag);
    bool IsMissionLocked(class APlayerController* PlayerController, const FBlamScenarioDataTableRow& ScenarioRow);
    bool IsInsertionPointLocked(class APlayerController* PlayerController, const FBlamScenarioDataTableRow& ScenarioRow, int32 InsertionPointIndex);
    bool IsInGameplayState(const class UObject* WorldContextObject);
    bool IsHDRSupportedAndAllowed();
    bool IsDLCPurchased(class APlayerController* PlayerController, FName EntitlementName);
    bool HasValidCurrentSavedGameIndex(class APlayerController* PlayerController);
    FPlatformUserId GetPlatformUserIdFromLocalUserIndex(int32 LocalUserIndex);
    EBlamGameModeSaveSlot GetLastSavedGameMode(class APlayerController* PlayerController);
    FGameplayTag GetEquippedObjectSkin(class APlayerController* PlayerController, FGameplayTag ObjectOrSkinName);
    bool GetDifficultyModifiersEnabled();
    FString GetBuildDateString();
    FString GetBuildChangelist();
    bool Debug_IsTerminalLocked(FName TerminalName);
    bool Debug_IsSkullLocked(EBlamGameSkulls GameSkull);
    int32 CompareFText(FText TextA, FText TextB);
    void CheckAndNotifyForCrossplayPrivileges(class APlayerController* PlayerController);
    bool CanResumeSaveSlot(class APlayerController* PlayerController, EBlamGameModeSaveSlot SaveSlot);
    bool CanResumeRemixSave(class APlayerController* PlayerController);
    bool CanResumeDLCSave(class APlayerController* PlayerController);
    bool CanResumeCampaignSave(class APlayerController* PlayerController);
}; // Size: 0x28

class UMeteoriteViewportHoldLocalPlayerSubsystem : public ULocalPlayerSubsystem
{

    void OnPossessedPawnChangedCallback(class APawn* OldPawn, class APawn* NewPawn);
    void OnBlamPawnUnitChangedCallback(class AActor* PreviousUnitActor, class AActor* NewUnitActor);
}; // Size: 0xB8

class UMeteoriteXboxNonPrimaryControllerSubsystem : public UGameInstanceSubsystem
{
}; // Size: 0x38

class UPendingPlayerSubsystem : public UGameInstanceSubsystem
{
    FPendingPlayerSubsystemOnPendingPlayerButtonPressed OnPendingPlayerButtonPressed; // 0x0030 (size: 0x10)
    void OnPendingPlayerButtonPressed(int32 UserIndex, FPlatformUserId PlatformUserId, FKeyEvent Input);

    void UnregisterSplitscreenButtonFocused();
    void UnregisterPendingPlayerButtonPress();
    void RegisterSplitscreenButtonFocused();
    void RegisterPendingPlayerButtonPress();
    void OnPendingPlayerButtonPressed__DelegateSignature(int32 UserIndex, FPlatformUserId PlatformUserId, FKeyEvent Input);
}; // Size: 0x68

class UPlayerEffectDataAsset : public UDataAsset
{
    bool bSuppressDirectionalDamageArrows;                                            // 0x0030 (size: 0x1)
    bool bShowWhenNoDamage;                                                           // 0x0031 (size: 0x1)
    bool bAreaOfEffect;                                                               // 0x0032 (size: 0x1)
    float DirectionalDamageArrowsDuration;                                            // 0x0034 (size: 0x4)

}; // Size: 0x38

class URetainerBoxLinearColor : public URetainerBox
{

    class UTextureRenderTarget2D* GetRenderTarget();
}; // Size: 0x1B0

class URosterFriendItemData : public UHaloUIViewItemData
{
    FText DisplayName;                                                                // 0x0108 (size: 0x10)
    FText Nickname;                                                                   // 0x0118 (size: 0x10)
    FText PresenceString;                                                             // 0x0128 (size: 0x10)
    ERosterPresenceStatus Status;                                                     // 0x0138 (size: 0x1)
    ERosterFriendPlatformType PlatformType;                                           // 0x0139 (size: 0x1)
    ERosterJoinability Joinability;                                                   // 0x013A (size: 0x1)

    void SetPresence(FText InPresenceString, ERosterPresenceStatus InStatus);
    void SetPlatformType(ERosterFriendPlatformType InPlatformType);
    void SetNickname(FText InNickname);
    void SetJoinability(ERosterJoinability InJoinabilityStatus);
    void SetDisplayName(FText InDisplayName);
    FText GetPresenceString();
    ERosterPresenceStatus GetPresenceStatus();
    ERosterFriendPlatformType GetPlatformType();
    FText GetNickname();
    ERosterJoinability GetJoinability();
    FText GetDisplayName();
}; // Size: 0x140

class USessionBusySubsystem : public UGameInstanceSubsystem
{

    void ShowInProgressForReason(FName Reason);
    void ShowInProgress();
    void HideInProgressForReason(FName Reason);
    void HideInProgress();
}; // Size: 0x98

class USettingsViewItemDataDropdownControllerPreset : public USettingsViewItemDataDropdownString
{
    TArray<class UHaloUIViewItemData*> OriginalChildInstances;                        // 0x01D8 (size: 0x10)

}; // Size: 0x1E8

class USettingsViewItemDataDropdownEnum : public USettingsViewItemDataDropdownInt
{
    TArray<class UHaloUIViewItemData*> OriginalChildInstances;                        // 0x01D8 (size: 0x10)

}; // Size: 0x1E8

class USettingsViewItemDataDropdownInt : public UHaloUIViewItemDataDropdown
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x01B8 (size: 0x18)

}; // Size: 0x1D0

class USettingsViewItemDataDropdownMaximumFrameRate : public USettingsViewItemDataDropdownEnum
{
}; // Size: 0x1E8

class USettingsViewItemDataDropdownMonitor : public USettingsViewItemDataDropdownString
{
}; // Size: 0x1E0

class USettingsViewItemDataDropdownNamedValues : public UHaloUIViewItemDataDropdown
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x01B8 (size: 0x18)

}; // Size: 0x1D0

class USettingsViewItemDataDropdownQualityPreset : public USettingsViewItemDataDropdownString
{
}; // Size: 0x1E0

class USettingsViewItemDataDropdownString : public UHaloUIViewItemDataDropdown
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x01B8 (size: 0x18)

}; // Size: 0x1D0

class USettingsViewItemDataDropdownTag : public UHaloUIViewItemDataDropdown
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x01B8 (size: 0x18)

}; // Size: 0x1D0

class USettingsViewItemDataDropdownUpscaler : public USettingsViewItemDataDropdownEnum
{
}; // Size: 0x1E8

class USettingsViewItemDataDropdownVoiceChatInputDevice : public USettingsViewItemDataDropdownString
{
    TWeakObjectPtr<class UMeteoriteVoiceSubsystem> VoiceSubsystem;                    // 0x01E0 (size: 0x8)

}; // Size: 0x1E8

class USettingsViewItemDataDropdownVoiceChatOutputDevice : public USettingsViewItemDataDropdownString
{
    TWeakObjectPtr<class UMeteoriteVoiceSubsystem> VoiceSubsystem;                    // 0x01E0 (size: 0x8)

}; // Size: 0x1E8

class USettingsViewItemDataDropdownWindowSize : public USettingsViewItemDataDropdownInt
{
}; // Size: 0x1E0

class USettingsViewItemDataFloat : public UHaloUIViewItemDataFloat
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x0140 (size: 0x18)

}; // Size: 0x158

class USettingsViewItemDataInteger : public UHaloUIViewItemDataInteger
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x0138 (size: 0x18)

}; // Size: 0x150

class USettingsViewItemDataIntegerFrameGeneration : public USettingsViewItemDataInteger
{
}; // Size: 0x150

class USettingsViewItemDataIntegerVSync : public USettingsViewItemDataInteger
{
}; // Size: 0x150

class USettingsViewItemDataSlider : public UHaloUIViewItemDataSlider
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x0178 (size: 0x18)

}; // Size: 0x190

class USettingsViewItemDataSliderInt : public UHaloUIViewItemDataSlider
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x0178 (size: 0x18)

}; // Size: 0x190

class USettingsViewItemDataText : public UHaloUIViewItemDataText
{
    FSettingsItemDataExtensionProperties ExtensionProperties;                         // 0x0128 (size: 0x18)

}; // Size: 0x140

class UShowErrorUI : public UBlueprintFunctionLibrary
{

    FAlertDataRow GetAlertData(FName AlertName);
    bool AlertPlayerControllerCustomText(class APlayerController* PlayerController, FText Title, FText Message);
    bool AlertPlayerController(class APlayerController* PlayerController, FName AlertName);
    bool AlertLocalPlayerCustomText(class ULocalPlayer* LocalPlayer, FText Title, FText Message);
    bool AlertLocalPlayer(class ULocalPlayer* LocalPlayer, FName AlertName);
    bool AlertDefaultPlayer(FName AlertName, class UObject* WorldContextObject);
}; // Size: 0x28

class UShowInProgressUI : public UBlueprintFunctionLibrary
{

    FInProgressDataRow GetInProgressData(FName InProgressName);
}; // Size: 0x28

class UTP_PickUpComponent : public USphereComponent
{
    FTP_PickUpComponentOnPickUp OnPickUp;                                             // 0x0510 (size: 0x10)
    void OnPickUp(class AMeteoriteCharacter* PickUpCharacter);

    void OnSphereBeginOverlap(class UPrimitiveComponent* OverlappedComponent, class AActor* OtherActor, class UPrimitiveComponent* OtherComp, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult);
}; // Size: 0x520

class UTP_WeaponComponent : public USkeletalMeshComponent
{
    TSubclassOf<class AMeteoriteProjectile> ProjectileClass;                          // 0x0F48 (size: 0x8)
    class USoundBase* FireSound;                                                      // 0x0F50 (size: 0x8)
    class UAnimMontage* FireAnimation;                                                // 0x0F58 (size: 0x8)
    FVector MuzzleOffset;                                                             // 0x0F60 (size: 0x18)
    class UInputMappingContext* FireMappingContext;                                   // 0x0F78 (size: 0x8)
    class UInputAction* FireAction;                                                   // 0x0F80 (size: 0x8)

    void Fire();
    void EndPlay(const TEnumAsByte<EEndPlayReason::Type> EndPlayReason);
    void AttachWeapon(class AMeteoriteCharacter* TargetCharacter);
}; // Size: 0xF90

class UTestMenuInputManager : public UUserWidget
{
    bool PlayerIsUsingMouseInput;                                                     // 0x02D0 (size: 0x1)
    int32 CurrentSelectedChild;                                                       // 0x02D4 (size: 0x4)
    FVector2D OldMousePos;                                                            // 0x02D8 (size: 0x10)

}; // Size: 0x2E8

class UUIItemInfo : public UPrimaryDataAsset
{
    FText ItemName;                                                                   // 0x0030 (size: 0x10)

}; // Size: 0x40

class UWatermarkSettings : public UDeveloperSettings
{
    bool bEnableWatermarkBetaLoose;                                                   // 0x0038 (size: 0x1)
    bool bEnableWatermarkBetaPackaged;                                                // 0x0039 (size: 0x1)
    bool bEnableWatermarkReleaseLoose;                                                // 0x003A (size: 0x1)
    bool bEnableWatermarkReleasePackaged;                                             // 0x003B (size: 0x1)
    bool bEnableWatermarkDefault;                                                     // 0x003C (size: 0x1)

    bool GetWatermarkEnabled();
}; // Size: 0x40

#endif

---CFG AlphaEnFolie
cfg = {
    commandName = 'emotePanel', -- Ouvrir le panneau des animations
    commandSuggestion = 'Ouvrir panneau Animations', -- Ouvrir la suggestion du panneau d'animations
    commandNameEmote = 'e', -- Jouer une animations
    commandNameSuggestion = 'Jouer une animation', -- Jouer une animations suggestion
    keyActive = true, -- Utiliser la clé pour ouvrir le panneau
    keyLetter = 'F3', -- Quelle clé pour ouvrir le panneau si keyActive est true
    keySuggestion = 'Ouvrez le panneau emote', --Suggestion sur le raccourcis clavier
    walkingTransition = 0.5,

    acceptKey = 38, -- Accepter l'animation partagée
    denyKey = 182, -- Refuser l'animation partagée
    waitBeforeWalk = 5000, --Attendez avant de revenir au style de marche

    -- pas toucher !
    useTnotify = GetResourceState('t-notify') == 'started',
    panelStatus = false,

    animActive = false,
    animDuration = 1500, -- Vous pouvez changer cela mais je vous déconseille. (Durée de l'animations)
    animLoop = false,
    animMovement = false,
    animDisableMovement = false,
    animDisableLoop = false,

    sceneActive = false,

    propActive = false,
    propsEntities = {},

    ptfxOwner = false,
    ptfxActive = false,
    ptfxEntities = {},
    ptfxEntitiesTwo = {},

    malePeds = {
        "mp_m_freemode_01"
    },

    sharedActive = false,

    cancelKey = 73, -- Touche par défaut pour annuler une animation. Les joueurs peuvent également modifier cela manuellement.
    defaultCommand = 'fav', -- Exécution de la commande Emote
    defaultEmote = 'dance', -- Emote par défaut dance
    defaultEmoteUseKey = true, -- Ne recommandez pas de définir ceci sur false, sauf si vous modifiez l'interface utilisateur
    defaultEmoteKey = 20 -- Touche de commande d'emote par défaut
}
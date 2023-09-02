enum Languages {
    English = 0,
    Polish  = 1,
    Russian = 2,
    Germany = 3
}

Loc <- {
    /**
     * @public
     * @description current language for systems.
     * Client can modify it. But for server i might be only "default" lang
     */
    language = Languages.English
}

/**
 * @public
 * @description get text from locale
 *
 * @param {string} sKey table key from `Loc`
 * @param {Languages} eLang language what we want use
 */
function Loc::getText(sKey, eLang = null) {
    if (eLang == null)
        eLang = Loc.language

    if (Loc.rawin(sKey) == false)
        return null;

    try {
        return Loc[sKey][eLang]
    } catch (e){
        // something wrong...
        return Loc[sKey][Languages.English]
    }
}

function Loc::setText(sKey, sText, eLang = null) {
    if (eLang == null)
        eLang = Loc.language

    if (Loc.rawin(sKey) == false)
        Loc[sKey] <- {}

    Loc[sKey][eLang] <- sText
}

function Loc::setTable(tObject) {
    foreach (key, value in tObject) {
        if (key == "localization")
            continue;

        Loc.setText(key, value, tObject.localization);
    }
}
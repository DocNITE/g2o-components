enum MiningParserTypes {
    String = 0,
    Array = 1
}

enum MiningRequireType {
    NonHand = 0,
    InHand = 1
}

MiningParser <- {};

function MiningParser::getDataFromString(data) {
    local resultData = {};

    local segments = split(data, ";");
    foreach (value in segments) {
        local keyarr = getKey(value);
        resultData[keyarr[0]] <- keyarr[1];
    }

    return resultData;
}

function MiningParser::setDataFromString(sData, tTable) {
    local segments = split(sData, ";");
    foreach (value in segments) {
        local keyarr = getKey(value);
        tTable[keyarr[0]] = keyarr[1];
    }
}

function MiningParser::getKey(line) {
    local data = split(line, "=");
    local arrayobject = getObject(data[1]);

    if (arrayobject == null) {
        try {
            return [data[0], data[1].tointeger()];
        } catch (e) {
            return [data[0], data[1]];
        }
    }

    return [data[0], arrayobject];
}

function MiningParser::getObject(line) {
    if (line.len() >= 2 && line.slice(0, 2) == "{}") {
        line = line.slice(2, line.len())

        local values = split(line, ",");
        local result = [];

        for (local z = 0; z < values.len(); z++) {
            local splited = split(values[z], "|");
            // convert some values into int
            for (local i = 0; i < splited.len(); i++) {
                try {
                    splited[i] = splited[i].tointeger();
                } catch (exception){
                    //splited[i] = splited[i];
                    splited[i] = getObject(splited[i]);

                }
            }
            result.push(splited);
        }

        return result;
    } else if (line.len() >= 2 && line.slice(0, 2) == "[]") {
        line = line.slice(2, line.len())

        local values = split(line, ",");

        for (local z = 0; z < values.len(); z++) {
            values[z] = values[z].tointeger();
        }

        return values;
    } else if (line.len() >= 1 && line.slice(0, 1) == "$") {
        line = line.slice(1, line.len())
        return line;
}
    else {
        return null;
    }
}

function MiningParser::isArray(line) {
    if (line.slice(0, 1) == "[")
        return [getObject(line)];
    else
        return line;
}

//local lol = "name=sword-farming;position=0,0,0;rotation=0,0,0;vob=null;price=20;time=2;resources=[]ITMW_SCHWERT|1,;";
//local data = MiningParser.getDataFromString(lol);
//print(data.resources[0].instance);

//local array = MiningParser.getArray("[]2|1,5|2");
//foreach (value1 in array) {
//    print(value1.instance);
//}
//TODO:
// Реализовать сохранку в файл нашего объекта TODO
// Реализовать добычу TODO
// Реализовать редактирование точек (на подобии вейпойнтов) TODO

// Далее пойдет фронтенд часть. Игрок должен поворачиваться к обьъекту и идти его долбить, как это было на ORS
local testGatch = MiningObject();
testGatch.id = "sword-farming";
testGatch.name = "mining sword"
testGatch.position = [0,0,0];
testGatch.vobVisual = "MIN_ORE_BIG_V1.3DS";
testGatch.require = [["ITMW_1H_SPECIAL_04", MiningRequireType.InHand]];
testGatch.resources = [["ITMW_SCHWERT", 2]];
testGatch.time = 10000;
MiningObject.getAllObjects().push(testGatch);
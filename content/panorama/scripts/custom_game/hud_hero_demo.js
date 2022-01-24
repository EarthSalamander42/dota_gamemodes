var picked_heroes = 1;
var max_picked_heroes = 5;

function ToggleEnemyHeroPicker() {
	$('#SelectAllyHeroContainer').SetHasClass('HeroPickerVisible', false)
	$('#SelectEnemyHeroContainer').ToggleClass('HeroPickerVisible');
}

function ToggleAllyHeroPicker() {
	$('#SelectEnemyHeroContainer').SetHasClass('HeroPickerVisible', false)
	$('#SelectAllyHeroContainer').ToggleClass('HeroPickerVisible');
}

function SpawnEnemyNewHero(nHeroID) {
	$('#SelectEnemyHeroContainer').RemoveClass('HeroPickerVisible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'SpawnEnemyButtonPressed', String(nHeroID));
}

function SpawnAllyNewHero(nHeroID) {
	$('#SelectAllyHeroContainer').RemoveClass('HeroPickerVisible');
	$.DispatchEvent('FireCustomGameEvent_Str', 'SpawnAllyButtonPressed', String(nHeroID));
}

function AllyRemoved(data) {
	var unit = ID_Map[data.unit] || data.unit;
	var container = $("#UnitItemContainer" + unit.toString());
	if (container) {
		container.DeleteAsync(FRAME_TIME);
	}
	$("#Hero" + unit.toString()).DeleteAsync(FRAME_TIME);
}

function AllySpawned(data) {
	$.Msg(data)

	var unit = data.unit;
	if (Entities.IsValidEntity(unit)) {
		SelectAndLookUnit(unit);

		var HeroItemText = '<Panel id="Hero' + unit.toString() + '" class="HeroImageItem" onactivate="SelectAndLookUnit(' + unit + ')">' +
			'<DOTAHeroImage id="HeroImage" class="TopBarHeroImage" heroname="' + GetHeroName(unit) + '" heroimagestyle="landscape" />'
			+ '</Panel>';
		$("#HeroImageContainer").BCreateChildren(HeroItemText);
	} else {
		$.Schedule(FRAME_TIME * 10, function () {
			AllySpawned(data);
		})
	}
}

function ShowDemoPanel() {
//	$.Msg("Enter Function ShowDemoPanel");
	$.GetContextPanel().FindChildTraverse('ControlPanel').SetHasClass("visible", true);
}

function HidePause(args) {
//	$.Msg("Enter Function ShowDemoPanel");
	$.Msg(args)
	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('PausedInfo').style.opacity = args.show;
}

(function () {
	$.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#SelectEnemyHeroContainer'), SpawnEnemyNewHero);
	$.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#SelectAllyHeroContainer'), SpawnAllyNewHero);
	GameEvents.Subscribe('AllySpawned', AllySpawned);
	GameEvents.Subscribe('AllyRemoved', AllyRemoved);
	GameEvents.Subscribe('hide_pause', HidePause);

	ShowDemoPanel();	
//	GameEvents.Subscribe('ShowDemoPanel', ShowDemoPanel);

	ID_Map = {};

	$('#SelectAllyHeroContainer').SetHasClass("HeroPickerVisible", false);

//	GetUniqueID = UniqueIDClosure();

})();

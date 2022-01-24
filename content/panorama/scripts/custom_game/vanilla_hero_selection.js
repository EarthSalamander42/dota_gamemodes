var GridCategories = FindDotaHudElement('GridCategories');
//	var total = herocard.GetChildCount();
var picked_heroes = [];
// var main_hero_picked = false;

//	$.Msg(herolist.customlist)
//	$.Msg(GridCategories)

function FindDotaHudElement(panel) {
	return $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse(panel);
}

(function() {
//	$.Msg("Init Vanilla Hero Selection")

//	var PreGame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame");
//	PreGame.style.opacity = "1";
//	PreGame.style.transitionDuration = "0.0s";
})();

local Scythe_Strings = {
	{
		language = "fr",		--french, français
		STR = {
			NAMES = "fauchet",
			RECIPE_DESC = "récolter rapidement",
			CHAR_DESC = "vite",
		},
		GOLD_STR = {
			NAMES = "faux d'or",
			RECIPE_DESC = "récolter rapidement",
			CHAR_DESC = "vite"
		},
		ACT_STR = "récolter",
	},
	{
		language = "es",		--spainish, español
		STR = {
			NAMES = "guadaña",
			RECIPE_DESC = "cosechar rápidamente",
			CHAR_DESC = "veloz",
		},
		GOLD_STR = {
			NAMES = "guadaña de oro",
			RECIPE_DESC = "cosechar rápidamente",
			CHAR_DESC = "veloz"
		},
		ACT_STR = "cosechar",
	},
--[[
	{
		language = "mex",		--mexican spainish, 
		STR = {
			NAMES = "",
			RECIPE_DESC = "",
			CHAR_DESC = "",
		},
		GOLD_STR = {
			NAMES = "",
			RECIPE_DESC = "",
			CHAR_DESC = ""
		},
		ACT_STR = "",
	},
]]
	{
		language = "de",		--german, deutsch
		STR = {
			NAMES = "Sense",
			RECIPE_DESC = "schnell ernten",
			CHAR_DESC = "schnell",
		},
		GOLD_STR = {
			NAMES = "goldene Sense",
			RECIPE_DESC = "schnell ernten",
			CHAR_DESC = "schnell"
		},
		ACT_STR = "ernten",
	},
	{
		language = "it",		--italian, italiano
		STR = {
			NAMES = "falce",
			RECIPE_DESC = "raccogliere velocemente",
			CHAR_DESC = "veloce",
		},
		GOLD_STR = {
			NAMES = "falce d'oro",
			RECIPE_DESC = "raccogliere velocemente",
			CHAR_DESC = "veloce"
		},
		ACT_STR = "raccogliere",
	},
	{
		language = "pt",		--portuguese, português
		STR = {
			NAMES = "foice",
			RECIPE_DESC = "colher rapidamente",
			CHAR_DESC = "velozes",
		},
		GOLD_STR = {
			NAMES = "foice dourada",
			RECIPE_DESC = "colher rapidamente",
			CHAR_DESC = "velozes"
		},
		ACT_STR = "colher",
	},
	{
		language = "br",		--brasilian, português brasileiro
		STR = {
			NAMES = "foice",
			RECIPE_DESC = "colher rapidamente",
			CHAR_DESC = "velozes",
		},
		GOLD_STR = {
			NAMES = "foice dourada",
			RECIPE_DESC = "colher rapidamente",
			CHAR_DESC = "velozes"
		},
		ACT_STR = "colher",
	},
	{
		language = "pl",		--polish, język polski
		STR = {
			NAMES = "Kosa",
			RECIPE_DESC = "zbierać szybko",
			CHAR_DESC = "szybki",
		},
		GOLD_STR = {
			NAMES = "złoty Kosa",
			RECIPE_DESC = "zbierać szybko",
			CHAR_DESC = "szybki"
		},
		ACT_STR = "zbierać",
	},
	{
		language = "ru",		--russian, русский язык
		STR = {
			NAMES = "коса",
			RECIPE_DESC = "косить быстро",
			CHAR_DESC = "быстрый",
		},
		GOLD_STR = {
			NAMES = "золотой коса",
			RECIPE_DESC = "косить быстро",
			CHAR_DESC = "быстрый"
		},
		ACT_STR = "косить",
	},
	{
		language = "ko",		--korean, 한국어, 韓國語
		STR = {
			NAMES = "큰 낫",
			RECIPE_DESC = "빨리 수확하다",
			CHAR_DESC = "빠른",
		},
		GOLD_STR = {
			NAMES = "황금 큰 낫",
			RECIPE_DESC = "빨리 수확하다",
			CHAR_DESC = "빠른"
		},
		ACT_STR = "베다",
	},
	{
		language = "ja",		--japanese, 日本語
		STR = {
			NAMES = "かま",
			RECIPE_DESC = "収穫作物",
			CHAR_DESC = "速い",
		},
		GOLD_STR = {
			NAMES = "ゴールデンかま",
			RECIPE_DESC = "もっと収穫",
			CHAR_DESC = "速い"
		},
		ACT_STR = "収穫",
	},
	{
		language = "zh",		--simp. chinese, 简体中文
		STR = {
			NAMES = "镰刀",
			RECIPE_DESC = "收获各种作物",
			CHAR_DESC = "很有效率",
		},
		GOLD_STR = {
			NAMES = "黄金镰刀",
			RECIPE_DESC = "像贵族一样收获",
			CHAR_DESC = "一分耕耘一分收获"
		},
		ACT_STR = "收获",
	},
	{
		language = "zht",			--trad. chinese, 繁體中文, language code in game
		STR = {
			NAMES = "鐮刀",
			RECIPE_DESC = "收穫各種作物",
			CHAR_DESC = "很有效率",
		},
		GOLD_STR = {
			NAMES = "黃金鐮刀",
			RECIPE_DESC = "像貴族一樣收穫",
			CHAR_DESC = "一分耕耘一分收穫"
		},
		ACT_STR = "收穫",
	},
	{
		language = "ch",			--trad. chinese, 繁體中文, language code for some language mod
		STR = {
			NAMES = "鐮刀",
			RECIPE_DESC = "收穫各種作物",
			CHAR_DESC = "很有效率",
		},
		GOLD_STR = {
			NAMES = "黃金鐮刀",
			RECIPE_DESC = "像貴族一樣收穫",
			CHAR_DESC = "一分耕耘一分收穫"
		},
		ACT_STR = "收穫",
	},
	--en in lowest position so that en will show when default language is not in the list
	{
		language = "en",		--english
		STR = {
			NAMES = "Scythe",
			RECIPE_DESC = "Gathering more effective.",
			CHAR_DESC = "Work Work Work.",
		},
		GOLD_STR = {
			NAMES = "Noble Scythe",
			RECIPE_DESC = "This is how the upper-class work.",
			CHAR_DESC = "My work worth."
		},
		ACT_STR = "Harvest",
	},
}

return Scythe_Strings
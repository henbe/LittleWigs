﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Mechano-Lord Capacitus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local aura = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Capacitus",

	trigger1 = "begins to cast Reflective Magic Shield.$",
	trigger2 = "begins to cast Reflective Damage Shield.$",
	trigger3 = "^Reflective Magic Shield fades",
	trigger4 = "^Reflective Damage Shield fades",

	warn1 = "Magic Reflection in 2 seconds!",
	warn2 = "Damage Shield in 2 seconds!",
	warn3 = "Magic Reflection down!",
	warn4 = "Damage Shield down!",

	magic = "Magic Reflection",
	magic_desc = "Warn for Magic Reflection",

	dmg = "Damage Shields",
	dmg_desc = "Warn for Damage Shields",

	polarity = "Polarity Shift(Heroic)",
	polarity_desc = "Warn when Polarity Shift is cast",
	polarity_trigger = "begins to cast Polarity Shift",
	polarity_warn = "Polarity Shift in 3 seconds!",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "마법 반사 보호막 시전을 시작합니다.$",
	trigger2 = "피해 반사 보호막 시전을 시작합니다.$",
	trigger3 = "마법 반사 효과가 사라졌습니다.", -- check
	trigger4 = "피해 반사 보호막 효과가 사라졌습니다.", -- check

	warn1 = "2초 이내 마법 반사!",
	warn2 = "2초 이내 피해 반사 보호막!",
	warn3 = "마법 반사 사라짐!",
	warn4 = "피해 반사 보호막 사라짐!",

	magic = "마법 반사",
	magic_desc = "마법 반사에 대한 경고",

	dmg = "피해 반사 보호막",
	dmg_desc = "피해 반사 보호막에 대한 경고",

	polarity = "극성 변환(영웅)",
	polarity_desc = "극성 변환 시전 시 경고",
	polarity_trigger = "기계군주 캐퍼시투스|1이;가; 극성 변환 시전을 시작합니다.", -- check
	polarity_warn = "3초 이내 극성 변환!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Tempest Keep"
mod.zonename = AceLibrary("Babble-Zone-2.2")["The Mechanar"]
mod.enabletrigger = boss 
mod.toggleoptions = {"magic", "dmg", -1, "polarity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	aura = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if not aura and self.db.profile.magic and msg:find(L["trigger1"]) then
		mod:NewPowers(1)
	elseif not aura and self.db.profile.dmg and msg:find(L["trigger2"]) then
		mod:NewPowers(2)
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if aura and (msg:find(L["trigger3"]) or msg:find(L["trigger4"])) then
		self:Message(aura == 1 and L["warn3"] or L["warn4"], "Attention")
		aura = nil
	end
end

function mod:NewPowers(power)
	aura = power
	self:Message(power == 1 and L["warn1"] or L["warn2"], "Important")
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.polarity and msg:find(L["polarity_trigger"]) then
		self:Message(L["polarity_warn"], "Urgent")
	end
end
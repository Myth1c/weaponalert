if SERVER then

	AddCSLuaFile("init_weaponalert.lua")
end


if CLIENT then

	armedWarningMat = Material("fadmin/icons/weapon")
	handcuffWarningMat = Material("fadmin/icons/jail")
	stunWarningMat = Material("hud/avatar_glow_64")
	criminalWarningMat = Material("hud/freeze_nemesis")

	armedPlayers = {}
	cuffPlayers = {}
	stunStickPlayers = {}
	criminalPlayers = {}

	validWeapons = 
	{
		-- Misc Weapons
		"weapon_fists",
		-- TFA Weapons
		"tfa_ins2_acr", "tfa_ins2_ak12", "tfa_ins2_akz", "tfa_ins2_arx160", "tfa_ins2_c7e_redux", "tfa_ins2_cz75", "tfa_ins2_cz805", "tfa_ins2_deagle", 
		"tfa_ins2_codol_free", "tfa_ins2_glock_p80", "tfa_ins2_gol", "tfa_ins2_416c", "tfa_ins2_k98", "tfa_ins2_thanez_cobra", "tfa_ins2_krissv", "tfa_ins2_ksg", "tfa_ins2_cq300", 
		"tfa_ins2_m1014", "tfa_ins2_m500", "tfa_ins2_m590o", "tfa_ins2_m9", "tfa_ins2_minimi", "tfa_ins2_mk18", "tfa_ins2_mp5k", "tfa_ins2_mp7", "tfa_ins2_codol_msr", 
		"tfa_ins2_nova", "tfa_ins2_groza", "tfa_ins2_mwr_p90", "tfa_ins2_rfb", "tfa_ins2_sw659", "tfa_ins2_l85a2", "tfa_ins2_sai_gry", "tfa_ins2_sc_evo", 
		"tfa_ins2_spas12", "tfa_ins2_spectre", "tfa_ins2_ump45", "tfa_ins2_mateba", "tfa_ins2_usp_match", 
		--Dark RP Default Weapons
		"weapon_ak472", "weapon_ak47custom", "weapon_deagle2", "weapon_fiveseven2", "weapon_glock2", "weapon_m42", "weapon_mac102", "weapon_mp52", 
		"weapon_p2282", "weapon_pumpshotgun2", "ls_sniper",
		-- HL2 Default Weapons
		"weapon_357", "weapon_pistol", "weapon_crossbow", "weapon_crowbar", "weapon_frag", "weapon_ar2", "weapon_rpg", "weapon_slam", "weapon_shotgun", "weapon_smg1", "weapon_stunstick"
	}
	validHandcuffs = 
	{
		"weapon_cuff_standard", "weapon_leash_elastic", "weapon_cuff_elastic", "weapon_cuff_plastic", "weapon_cuff_police", "weapon_cuff_shackles", "weapon_cuff_tactical",
		"weapon_leash_rope", "weapon_cuff_rope", "arrest_stick",
	}
	validStunSticks = 
	{
		"stunstick"
	}
	validCriminalWeapons = 
	{
		"lockpick", "bkeypads_cracker"
	}



	thinkInterval = 1



	


	local function ArmedPlayersCheckThink()

		--print("---checking for armed players...")

		for k, v in pairs(player.GetAll()) do

			--print("Checking player: "..v:Nick())

			if IsValid(v) && LocalPlayer():GetPos():Distance(v:GetPos()) <= 600 then

				local equipedWeapon = nil

				local status, returnVal = pcall(getPlayerWeapon, v)

				if status ~= true then print("PCall function has encountered an error.\nPlease report this to an admin.\nStatus: ", status, "\nError Message: ", returnVal) return end

				if returnVal == nil then return
				else equipedWeapon = returnVal end

				armed = false
				cuffs = false
				aStick = false
				criminal = false

				if table.HasValue(armedPlayers, v:SteamID64()) and !armed then

					--print("Removing player from table.")

					table.RemoveByValue(armedPlayers,v:SteamID64())
				end
				if table.HasValue(cuffPlayers, v:SteamID64()) and !cuffs then

					--print("Removing player from table.")

					table.RemoveByValue(cuffPlayers,v:SteamID64())
				end
				if table.HasValue(stunStickPlayers, v:SteamID64()) and !aStick then

					--print("Removing player from table.")

					table.RemoveByValue(stunStickPlayers,v:SteamID64())
				end
				if table.HasValue(criminalPlayers, v:SteamID64()) and !criminal then

					--print("Removing player from table.")

					table.RemoveByValue(criminalPlayers,v:SteamID64())
				end

				-- Check for weapons first
				for key, value in pairs(validWeapons) do

					--print("\nEquiped weapon:"..equipedWeapon)
					--print("Checking against: "..value)

					if equipedWeapon == value then

						--print("\nPlayer is armed! checking table eligability...\n")

						armed = true
					end
				end

				if !table.HasValue(armedPlayers, v:SteamID64()) and armed then

					--print("Adding player to table.")

					table.insert(armedPlayers, v:SteamID64())

					return
				end

				-- Check for cuffs next
				for key, value in pairs(validHandcuffs) do

					--print("\nEquiped weapon:"..equipedWeapon)
					--print("Checking against: "..value)

					if equipedWeapon == value then

						--print("\nPlayer is armed! checking table eligability...\n")
						cuffs = true
					end
				end

				if !table.HasValue(cuffPlayers, v:SteamID64()) and cuffs then

					--print("Adding player to table.")

					table.insert(cuffPlayers, v:SteamID64())
					
					return
				end
				-- check our criminal weapons table
				for key, value in pairs(validCriminalWeapons) do

					--print("\nEquiped weapon:"..equipedWeapon)
					--print("Checking against: "..value)

					if equipedWeapon == value then

						--print("\nPlayer is armed! checking table eligability...\n")
						criminal = true
					end
				end

				if !table.HasValue(criminalPlayers, v:SteamID64()) and criminal then

					--print("Adding player to table.")

					table.insert(criminalPlayers, v:SteamID64())
					
					return
				end
				-- Finally check our unarrest stick table
				for key, value in pairs(validStunSticks) do

					--print("\nEquiped weapon:"..equipedWeapon)
					--print("Checking against: "..value)

					if equipedWeapon == value then

						--print("\nPlayer is armed! checking table eligability...\n")
						aStick = true
					end
				end

				if !table.HasValue(stunStickPlayers, v:SteamID64()) and aStick then

					--print("Adding player to table.")

					table.insert(stunStickPlayers, v:SteamID64())
					
					return
				end

				--print("armed value: ")
				--print(armed)


				--PrintTable(armedPlayers)
				--PrintTable(cuffPlayers)
				--PrintTable(arrestingPlayers)
			end
		end
	end

	function getPlayerWeapon(v)

		--print("Checking for armed players...")

		if IsValid(v) && v:Alive() && !v:isArrested() then

			--print("Valid Player found.\nChecking Weapon.")

			local equipedWeapon = v:GetActiveWeapon():GetClass()

			--print("Weapon: ", equipedWeapon)

			return equipedWeapon

		end


	end

	local function drawWarning()


		for k, v in pairs(armedPlayers) do

			--print("starting drawing...\n")
			--print("checking player: ")
			--print(v.."\n")

			if !IsValid(player.GetBySteamID64( v )) || !(player.GetBySteamID64( v ):Alive()) then return end

			--print("player valid")
			--print("drawing...")

			local offset = Vector( 0, 0, -25)

			local attach_id = player.GetBySteamID64( v ):LookupAttachment( 'eyes' )
			if not attach_id then return end

			local attach = player.GetBySteamID64( v ):GetAttachment( attach_id )

			if not attach then return end
			
			local playerPos = attach.Pos + offset

			
			local ang = LocalPlayer():GetAngles()

			ang.y = LocalPlayer():GetAngles().y
			ang.p = - 90

			ang:RotateAroundAxis( ang:Up(), -90)

			

			cam.Start3D2D( playerPos, ang, 1 )

				surface.SetDrawColor( 255, 255, 255, (CurTime()*300 % 255)*.2 )
				surface.SetMaterial(armedWarningMat)
				surface.DrawTexturedRect( -5, -65, 10, 10)
			cam.End3D2D()
		end

		for k, v in pairs(cuffPlayers) do

			--print("starting drawing...\n")
			--print("checking player: ")
			--print(v.."\n")

			if !IsValid(player.GetBySteamID64( v )) || !(player.GetBySteamID64( v ):Alive()) then return end

			--print("player valid")
			--print("drawing...")

			local offset = Vector( 0, 0, -25)

			local attach_id = player.GetBySteamID64( v ):LookupAttachment( 'eyes' )
			if not attach_id then return end

			local attach = player.GetBySteamID64( v ):GetAttachment( attach_id )

			if not attach then return end
			
			local playerPos = attach.Pos + offset

			
			local ang = LocalPlayer():GetAngles()

			ang.y = LocalPlayer():GetAngles().y
			ang.p = - 90

			ang:RotateAroundAxis( ang:Up(), -90)

			

			cam.Start3D2D( playerPos, ang, 1 )

				surface.SetDrawColor( 255, 255, 255, (CurTime()*300 % 255)*.2 )
				surface.SetMaterial(handcuffWarningMat)
				surface.DrawTexturedRect( -5, -65, 10, 10)
			cam.End3D2D()
		end

		for k, v in pairs(stunStickPlayers) do

			--print("starting drawing...\n")
			--print("checking player: ")
			--print(v.."\n")

			if !IsValid(player.GetBySteamID64( v )) || !(player.GetBySteamID64( v ):Alive()) then return end

			--print("player valid")
			--print("drawing...")

			local offset = Vector( 0, 0, -25)

			local attach_id = player.GetBySteamID64( v ):LookupAttachment( 'eyes' )
			if not attach_id then return end

			local attach = player.GetBySteamID64( v ):GetAttachment( attach_id )

			if not attach then return end
			
			local playerPos = attach.Pos + offset

			
			local ang = LocalPlayer():GetAngles()

			ang.y = LocalPlayer():GetAngles().y
			ang.p = - 90

			ang:RotateAroundAxis( ang:Up(), -90)

			

			cam.Start3D2D( playerPos, ang, 1 )

				surface.SetDrawColor( 255, 255, 255, (CurTime()*300 % 255)*.2 )
				surface.SetMaterial(stunWarningMat)
				surface.DrawTexturedRect( -5, -65, 10, 10)
			cam.End3D2D()
		end

		for k, v in pairs(criminalPlayers) do

			--print("starting drawing...\n")
			--print("checking player: ")
			--print(v.."\n")

			if !IsValid(player.GetBySteamID64( v )) || !(player.GetBySteamID64( v ):Alive()) then return end

			--print("player valid")
			--print("drawing...")

			local offset = Vector( 0, 0, -25)

			local attach_id = player.GetBySteamID64( v ):LookupAttachment( 'eyes' )
			if not attach_id then return end

			local attach = player.GetBySteamID64( v ):GetAttachment( attach_id )

			if not attach then return end
			
			local playerPos = attach.Pos + offset

			
			local ang = LocalPlayer():GetAngles()

			ang.y = LocalPlayer():GetAngles().y
			ang.p = - 90

			ang:RotateAroundAxis( ang:Up(), -90)

			

			cam.Start3D2D( playerPos, ang, 1 )

				surface.SetDrawColor( 255, 255, 255, (CurTime()*300 % 255)*.2 )
				surface.SetMaterial(criminalWarningMat)
				surface.DrawTexturedRect( -5, -65, 10, 10)
			cam.End3D2D()
		end

	end
	hook.Add( "PreDrawEffects", "DrawArmedIcon", drawWarning)








	local function Initialize()

		timer.Create("armedPlayersCheckTimer", thinkInterval, 0, ArmedPlayersCheckThink)
	end
	hook.Add("Initialize", "Initializesnweaponalert", Initialize)
end
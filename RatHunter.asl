//	Rat Hunter Autosplitter Version 1.0 17 Jan 2025
//	By TheDementedSalad
//	Supports Load Remover & Level Splits


// Special thanks to:
// TheDementedSalad - Created Splitter, code & splits
// Rumii - Helped figure out the correct base address
// SabulineHorizon - Testing

state("RatHunter")
{
	bool		Loading:		0x28B1C0, 0x88;
	//string100	bspMap:			0x28B1C0, 0x120, 0x24, 0x8;
	string100	GameState:		0x28B1C0, 0x120, 0x30, 0x0;
}

startup
{
	timer.CurrentTimingMethod = TimingMethod.GameTime;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/RatHunt.Settings.xml");
}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case (2916352):
			version = "Release";
			break;
	}
	
	vars.splits = new HashSet<string>();
	vars.pausenames = new HashSet<string>(){"start.xml", "outro.xml", "IntroAnim.xml", "videor2.xml", "MainMenu.xml", "Logo.xml"};
}

onStart
{
	//resets the splits when a new run starts
	vars.splits.Clear();
}

update
{	
	//print(modules.First().ModuleMemorySize.ToString());
}

start
{
	return !current.Loading && old.Loading && current.GameState == "1.xml";
}

split
{
	string setting = "";
	
	if(current.GameState != old.GameState && !string.IsNullOrEmpty(current.GameState)){
		setting = "Level_" + current.GameState;
	}
	
	if(current.GameState == "outro.xml" && string.IsNullOrEmpty(old.GameState)){
		return true;
	}

	// Debug. Comment out before release.
	if (!string.IsNullOrEmpty(setting))
	vars.Log(setting);

	if (settings.ContainsKey(setting) && settings[setting] && vars.splits.Add(setting)){
		return true;
	}
}

isLoading
{
	return current.Loading || string.IsNullOrEmpty(current.GameState) || vars.pausenames.Contains(current.GameState);
}

reset
{
	return current.Loading && (old.GameState != "1.xml" && current.GameState == "1.xml");
}

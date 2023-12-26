using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Marsey.PatchAssembly;
using Marsey.Patches;
using Marsey.Misc;
using Marsey.Stealthsey;
using Marsey.Stealthsey.Reflection;

namespace Marsey.Subversion;

/// <summary>
/// Manages patches/addons based on the Subverter patch
/// </summary>
public static class Subverter
{
    public const string MarserializerFile = "subversion.marsey";

    /// <summary>
    /// Hides a subversion module from the game
    /// </summary>
    /// <remarks>Assigned to a delegate in Subverter.dll</remarks>
    [HideLevelRequirement(HideLevel.Unconditional)]
    private static void Hide(Assembly asm)
    {
        Hidesey.HidePatch(asm);
    }
    
    public static List<SubverterPatch> GetSubverterPatches() => PatchListManager.GetPatchList<SubverterPatch>();
}

public class SubverterPatch : IPatch
{
    public string Asmpath { get; set; }
    public Assembly Asm { get; set; }
    public string Name { get; set; } 
    public string Desc { get; set; }
    public MethodInfo? Entry { get; set; }
    public bool Enabled { get; set; }
    
    public SubverterPatch(string asmpath, Assembly asm, string name, string desc)
    {
        Asmpath = asmpath;
        Name = name;
        Desc = desc;
        Asm = asm;

        if (Subverse.CheckSubverterDuplicate(this))
        {
            throw new PatchAssemblyException(
                "Tried to create a SubverterPatch that is the same as Subverter! Remove Subverter.dll from the patches folder!");
        }
    }
}
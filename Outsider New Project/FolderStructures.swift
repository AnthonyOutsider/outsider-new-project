import Foundation

func getSubfolders(for projectType: String) -> [String: [String]] {
    switch projectType {
    case "Live Action":
        return ["pro": ["assets", "shots", "config", "assets/chars", "assets/props", "assets/sets", "assets/lib", "assets/maps", "assets/lgt", "assets/cam", "assets/fx", "assets/poses", "assets/nodes", "assets/scripts", "shots/000_titles"],
                "pre": ["shots", "assets", "char"],
                "dev": ["concepts", "boards", "tests"],
                "edit": [],
                "blender_project": [],
                "cinema4d_project": [],
                "aftereffects_project": [],
                "illustrator_project": [],
                "davinci_project": [],
                "misc_project": []]
    case "2D Animation":
        return ["pro": ["assets", "shots", "config", "assets/chars", "assets/props", "assets/sets", "assets/lib", "assets/maps", "assets/lgt", "assets/cam", "assets/fx", "assets/poses", "assets/nodes", "assets/scripts", "shots/000_titles"],
                "pre": ["shots", "assets", "char"],
                "dev": ["concepts", "boards", "tests"],
                "edit": [],
                "blender_project": [],
                "cinema4d_project": [],
                "aftereffects_project": [],
                "illustrator_project": [],
                "davinci_project": [],
                "misc_project": []]
    case "3D Animation":
        return ["pro": ["assets", "shots", "config", "assets/chars", "assets/props", "assets/sets", "assets/lib", "assets/maps", "assets/lgt", "assets/cam", "assets/fx", "assets/poses", "assets/nodes", "assets/scripts", "shots/000_titles"],
                "pre": ["shots", "assets", "char"],
                "dev": ["concepts", "boards", "tests"],
                "edit": [],
                "blender_project": [],
                "cinema4d_project": [],
                "aftereffects_project": [],
                "illustrator_project": [],
                "davinci_project": [],
                "misc_project": []]
    default:
        return [:]
    }
}

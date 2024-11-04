cask "material-maker" do
  version "1.3"
  sha256 "0f88cf40438ac2cd8915cce1d0ae79991d3c8c804c53a8ce14e9ba4f21719edf"

  url "https:github.comRodZill4material-makerreleasesdownload#{version}material_maker_#{version.dots_to_underscores}.dmg",
      verified: "github.comRodZill4material-maker"
  name "Material Maker"
  desc "Procedural material authoring and 3D painting tool based on the Godot Engine"
  homepage "https:rodzilla.itch.iomaterial-maker"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "material_maker.app"

  zap trash: [
    "~LibraryApplication SupportCrashReportermaterial_maker*.plist",
    "~LibraryApplication Supportmaterial_maker",
    "~LibrarySaved Application Statecom.rodzlabs.materialmaker.savedState",
  ]
end
cask "lightburn" do
  version "1.5.02"
  sha256 "429f99c3768c160083bd83173e51dc9f31d50f4298287d3531d536d92eea1891"

  url "https:github.comLightBurnSoftwaredeploymentreleasesdownload#{version}LightBurn.V#{version}.dmg",
      verified: "github.comLightBurnSoftwaredeployment"
  name "LightBurn"
  desc "Layout, editing, and control software for laser cutters"
  homepage "https:lightburnsoftware.com"

  app "LightBurn.app"

  zap trash: [
    "~LibraryPreferencescom.LightBurnSoftware.LightBurn.plist",
    "~LibraryPreferencesLightBurn",
    "~LibrarySaved Application Statecom.LightBurnSoftware.LightBurn.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
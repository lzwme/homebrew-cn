cask "lightburn" do
  version "1.4.05"
  sha256 "c521818399f5a6fb73f9916125c4cf416590b7e4ad55c272b3b34e22969d64d0"

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
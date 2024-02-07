cask "lightburn" do
  version "1.5.00"
  sha256 "249fcfbbd7abe11b85d997476765111727e51c1dd2a9f9fe9c81fd048f4e4331"

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
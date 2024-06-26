cask "lightburn" do
  version "1.6.03"
  sha256 "98342ed9285ca2e5007c634c11ef7d5a14dc10714f8c4dbbd58fc1fc245a9b93"

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
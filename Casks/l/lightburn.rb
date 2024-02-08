cask "lightburn" do
  version "1.5.01"
  sha256 "7752c4d46739bcf7b0da21942b8773bdc96ced9dc09fe1f76e060a9466667698"

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
cask "galaxybudsclient" do
  arch arm: "arm64", intel: "x64"

  version "5.0.0"
  sha256 arm:   "b52c050eeda42ae2eecbcb6555d20ab522b31c5d75cd378bb29c744ce1f6fe8f",
         intel: "8844bee0102e947c173d9e3d71abeb4ed31efcf96c5fea8e3ccc75cada1024e7"

  url "https:github.comThePBoneGalaxyBudsClientreleasesdownload#{version}GalaxyBudsClient_macOS_#{arch}.pkg"
  name "GalaxyBudsClient"
  desc "Unofficial manager for the Buds, Buds+, Buds Live and Buds Pro"
  homepage "https:github.comThePBoneGalaxyBudsClient"

  depends_on macos: ">= :monterey"

  pkg "GalaxyBudsClient_macOS_#{arch}.pkg"

  uninstall pkgutil: "me.timschneeberger.galaxybudsclient"

  zap trash: [
    "~LibraryApplication SupportGalaxyBudsClient",
    "~LibraryPreferencesme.timschneeberger.galaxybudsclient.plist",
    "~LibrarySaved Application Stateme.timschneeberger.galaxybudsclient.savedState",
  ]
end
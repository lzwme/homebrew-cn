cask "galaxybudsclient" do
  arch arm: "arm64", intel: "x64"

  version "5.0.1"
  sha256 arm:   "052c31062af7854cc60191df78fd19a7da99c67d30feb712f560367d2162857f",
         intel: "4228910f96ed2fe9e8317e8248de39917ff087f3b6c68b1395164dbb476c60c7"

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
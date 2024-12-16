cask "galaxybudsclient" do
  arch arm: "arm64", intel: "x64"

  version "5.1.1"
  sha256 arm:   "4072280207e374ab7c9fe27ef2bf6ca5dcfcf7edfd428a3432c0cdc35dc15eab",
         intel: "cd6da78f5b6b86feafdb7921619fba8451e5c07a59e0d415af255c23c59f7ef8"

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
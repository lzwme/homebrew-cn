cask "galaxybudsclient" do
  arch arm: "arm64", intel: "x64"

  version "4.6.0"
  sha256 arm:   "be1d12605ae486fe1713fd8afcb977a2e0b13ae836aeb60bd19cfe8c4c49faec",
         intel: "780f14421ab6986cf88394151cd1d20f491613b7c23721d7803856b5aa53c8eb"

  url "https:github.comThePBoneGalaxyBudsClientreleasesdownload#{version}GalaxyBudsClient_macOS-#{arch}.pkg"
  name "GalaxyBudsClient"
  desc "Unofficial manager for the Buds, Buds+, Buds Live and Buds Pro"
  homepage "https:github.comThePBoneGalaxyBudsClient"

  depends_on macos: ">= :sonoma"

  pkg "GalaxyBudsClient_macOS-#{arch}.pkg"

  uninstall pkgutil: "me.timschneeberger.galaxybudsclient"

  zap trash: [
    "~LibraryApplication SupportGalaxyBudsClient",
    "~LibraryPreferencesme.timschneeberger.galaxybudsclient.plist",
    "~LibrarySaved Application Stateme.timschneeberger.galaxybudsclient.savedState",
  ]
end
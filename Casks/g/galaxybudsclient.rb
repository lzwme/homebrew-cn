cask "galaxybudsclient" do
  arch arm: "arm64", intel: "x64"

  version "5.1.0"
  sha256 arm:   "569c6c918671fc6d9451c5c544fe3bf72831337b6c20deecfeaa80e0b5dfed7f",
         intel: "58edbc165e4140b8a9d2229d0c92b00fea1dd528032fd5906820403a4e5fcacf"

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
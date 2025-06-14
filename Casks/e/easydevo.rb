cask "easydevo" do
  version "0.3.4"
  sha256 "3795f382bcb765a11b83ddb66c3f860471f23518f26a85c08ed08426a7711b79"

  url "https:github.comboring-designEasyDevo-Distroreleasesdownloadv#{version}EasyDevo-Mac-#{version}-Installer.dmg",
      verified: "github.comboring-designEasyDevo-Distro"
  name "EasyDevo"
  desc "Elegant tool built for coding"
  homepage "https:easydevo.boringboring.design"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "EasyDevo.app"

  zap trash: [
    "~LibraryApplication SupportEasyDevo",
    "~LibraryLogsEasyDevo",
    "~LibraryPreferencesdev.strrl.easydevo.plist",
    "~LibrarySaved Application Statedev.strrl.easydevo.savedState",
  ]
end
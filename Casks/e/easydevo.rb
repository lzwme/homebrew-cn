cask "easydevo" do
  version "0.3.3"
  sha256 "6723db5797fa51dde637cf1907ad0243a4af3c6a5dc9e2ac87062c9278c024c8"

  url "https:github.comboring-designEasyDevo-Distroreleasesdownloadv#{version}EasyDevo-Mac-#{version}-Installer.dmg",
      verified: "github.comboring-designEasyDevo-Distro"
  name "EasyDevo"
  desc "Elegant tool built for coding"
  homepage "https:easydevo.boringboring.design"

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
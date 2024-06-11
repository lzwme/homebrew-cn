cask "devpod" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.13"
  sha256 arm:   "41268d983a26c4c6587e0e6f93a7899c4b0e4d16448c2e43ef6f0d49addff790",
         intel: "261d48987dd7d0831479b759828bf83b4d53c4500e5b88e647b57f6e5a4a0774"

  url "https:github.comloft-shdevpodreleasesdownloadv#{version}DevPod_macos_#{arch}.dmg",
      verified: "github.comloft-shdevpod"
  name "DevPod"
  desc "UI to create reproducible developer environments based on a devcontainer.json"
  homepage "https:devpod.sh"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DevPod.app"
  binary "#{appdir}DevPod.appContentsMacOSdevpod-cli", target: "devpod"

  zap trash: [
    "~.devpod",
    "~LibraryApplication Supportsh.loft.devpod",
    "~LibraryCachessh.loft.devpod",
    "~LibraryLogssh.loft.devpod",
    "~LibraryPreferencessh.loft.devpod.plist",
    "~LibrarySaved Application Statesh.loft.devpod.savedState",
    "~LibraryWebKitsh.loft.devpod",
  ]
end
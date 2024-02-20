cask "devpod" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.3"
  sha256 arm:   "9319b8bd26f588a40e34bd08e02ef9223d0b297bbfc1898fdbaae0ee9e8eb83e",
         intel: "07f407ae3dc0f3ea6126175fcf3c62b67d2f5f06b0a9cbc5911082a39205a326"

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
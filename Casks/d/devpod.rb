cask "devpod" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.10"
  sha256 arm:   "4dc295e8f0b34b175e52259e98eaaf382cffb68658b0b65d0a2a8132a806e32f",
         intel: "99f42d56646356d86b8afaa983be71d6065be5e144d74eeda686488d61109751"

  url "https:github.comloft-shdevpodreleasesdownloadv#{version}DevPod_macos_#{arch}.dmg",
      verified: "github.comloft-shdevpod"
  name "DevPod"
  desc "UI to create reproducible developer environments based on a devcontainer.json"
  homepage "https:devpod.sh"

  livecheck do
    url :url
    strategy :github_latest
  end

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
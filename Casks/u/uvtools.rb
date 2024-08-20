cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.4.1"
  sha256 arm:   "4137593359c561c703288ec23a62ade632a0349b1a2838f3bb98de7260cfe058",
         intel: "568a203a46ac4f0966e3a91daa39424ba9318625ad32bb271b699f429f33674d"

  url "https:github.comsn4k3UVtoolsreleasesdownloadv#{version}UVtools_osx-#{arch}_v#{version}.zip"
  name "UVtools"
  desc "MSLADLP, file analysis, calibration, repair, conversion and manipulation"
  homepage "https:github.comsn4k3UVtools"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "UVtools.app"

  zap trash: [
    "~LibraryPreferencescom.UVtools.plist",
    "~LibrarySaved Application Statecom.UVtools.savedState",
  ]
end
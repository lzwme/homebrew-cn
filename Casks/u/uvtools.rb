cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.0.6"
  sha256 arm:   "0b9ab8fb3810b8ea39c52deba5d487c0c4e71c4d65437b6ee8557d182e7e7ebf",
         intel: "6263150a11eb88604cfd839dd1c9c0c89abf0ebb0dea615774bac00d39b42b3d"

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
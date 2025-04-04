cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.9"
  sha256 arm:   "0f91f31ccbdd61f77455eb0eb384a9789167f13f0e9090240a1b5b43f6b2ed8f",
         intel: "2615b4552c9d553f6dd73bd0a9f1999f15975f096b9bf5b5b67b27883d473c0a"

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
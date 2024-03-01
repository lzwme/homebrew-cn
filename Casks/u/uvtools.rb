cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.3"
  sha256 arm:   "180baf70a6c2c07e3270814bc907ef07336b75db9dfad0d4c0236634c35595c9",
         intel: "344ef1d7385d338963fd1e45a3e515b86097fc92e413e1d0c7468f8ef51248ba"

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
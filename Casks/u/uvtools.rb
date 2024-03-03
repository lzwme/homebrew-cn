cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.4"
  sha256 arm:   "9aa4d29ee39e952f60554b054ba6f3224a04bffcde32eb32c2ec4508f89de0f2",
         intel: "e8c334fe22d3f0d854df2e7318dcc3fc265180fd446e18bdde418f74d291dd44"

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
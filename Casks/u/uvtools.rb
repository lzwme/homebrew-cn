cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.1.4"
  sha256 arm:   "515f4fd94c00f4afd7d66e2949d6d93ebf240c8dd4e1f2d8bf4bf5633da0a58c",
         intel: "a1b24175f21cbfef918147597de50df5608a59135da861ab40c20acd0fabda71"

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
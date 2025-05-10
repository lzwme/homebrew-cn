cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.1.1"
  sha256 arm:   "0c2288d6c677579c888836b6e9dc564ebd6cfc97218ddf2f9e055dde2ebe9068",
         intel: "c28c71eebebefd2744c114aa8d5eb9db0bdfaebed4228353a99e1b32503849af"

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
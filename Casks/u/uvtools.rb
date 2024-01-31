cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.0"
  sha256 arm:   "5f70ddfcac645f97cbd92fe4fe7aef9b5391a9b5827c7603143cbbaea93b4b97",
         intel: "94d983e9491061cb6a3eac299399feb9131b339a9fb7607ee304c7036e08fe59"

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
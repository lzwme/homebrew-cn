cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.7"
  sha256 arm:   "49270629b027f1484f10fc44d15c5482f35f7947e723cad72fb03153c2a8aba0",
         intel: "f5a92b8cad477d72939bee9271fa864677337f96797d887db8b171d32599c2f6"

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
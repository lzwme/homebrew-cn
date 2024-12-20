cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.2"
  sha256 arm:   "cd890f26cb69bb27732d2c7a82c68df3f01366d5b72109674100c46e24e62fdc",
         intel: "7f42e9065ea5fb636d6f13df48265bb2c4c4f3ae54d912f04a41929fc230c520"

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
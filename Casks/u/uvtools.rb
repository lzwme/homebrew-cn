cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.1"
  sha256 arm:   "fce146c475f77104c809a23960eb9d0a4915e3fe3c349831b13e38a3b8c4d2cb",
         intel: "cf274e176e2e7cb1fd9819bd2099eb5da485d3552c210966c693541b54aa7b40"

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
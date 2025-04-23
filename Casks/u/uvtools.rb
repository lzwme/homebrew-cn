cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.1.0"
  sha256 arm:   "63f265777c2ed391fd09dc904af4e45394c207dd31d17f8f8e75291e8930478b",
         intel: "8d73c75eb0751325bf07bd997b3289cda5dab441c443617beb75a6e3a62b362c"

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
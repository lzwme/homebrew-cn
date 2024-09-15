cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.4.2"
  sha256 arm:   "6f3a261c28273c4240cfbf323cd0c2bfbff982e9ed5d4c8837d9791091f513bb",
         intel: "1d6ce0fe4fcafd16e1466b646bfc765e7a2974d5bde553131f5155692789a7bf"

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
cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "5.0.4"
  sha256 arm:   "284faf3a0d1b689c1bc196b549ea98b93815f3582b81d556931b2b3d188b817c",
         intel: "c880081998424159f264c75bed40f5b00d8152a0a1da22a6f3fc1a4f12ca09d8"

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
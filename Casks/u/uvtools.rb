cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.4.3"
  sha256 arm:   "da76abd3bb96561c0c2ad24774c30d18c9e8184236b78cc8e61174fffda439f8",
         intel: "3d45c45543364b54bda23885a433c18395ff57a623c58bbfac5f2fc82b356554"

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
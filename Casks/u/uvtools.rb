cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.2.5"
  sha256 arm:   "d206693cf97584f4aa9ee5f73f876ff6f11d1a9ccda695e7201b94f469c07ead",
         intel: "1a7b3b5adf5cf8b7023c9ab470f6b4c4d9ebf775a58294fefe5e836e4084458b"

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
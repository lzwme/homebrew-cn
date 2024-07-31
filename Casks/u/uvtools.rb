cask "uvtools" do
  arch arm: "arm64", intel: "x64"

  version "4.4.0"
  sha256 arm:   "d22d86f2c65dc9de1605c351d06ccbcf1e294fe51efe4f3dfb730bd33a24f02a",
         intel: "62680000f3f726a22c6b819774493a1862ff0934e6a64298c9b0a9ec423f3cd9"

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
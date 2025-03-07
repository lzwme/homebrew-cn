cask "xemu" do
  version "0.8.25"
  sha256 "4d490bea61749f2aa03827dcb7f0cb94ba3651bbe957b207417985da496dde0d"

  url "https:github.comxemu-projectxemureleasesdownloadv#{version}xemu-macos-universal-release.zip",
      verified: "github.comxemu-projectxemu"
  name "Xemu"
  desc "Original Xbox Emulator"
  homepage "https:xemu.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Xemu.app"

  zap trash: [
    "~LibraryApplication Supportxemu",
    "~LibraryPreferencesxemu.app.0.plist",
    "~LibrarySaved Application Statexemu.app.0.savedState",
  ]
end
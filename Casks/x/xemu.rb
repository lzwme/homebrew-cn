cask "xemu" do
  version "0.7.140"
  sha256 "c29ec3aeb965a6616390b0cbf286cfc558db352101a27edb25922b49742e335e"

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
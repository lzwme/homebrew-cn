cask "xemu" do
  version "0.8.46"
  sha256 "dadb9e42c9f7d2427a1e034a3b3122b1a3f744e659aa137ddd3973c656b7604b"

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
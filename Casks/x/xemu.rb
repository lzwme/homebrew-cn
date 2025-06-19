cask "xemu" do
  version "0.8.74"
  sha256 "f2a613249e4d657945b4ac403e17b430155104c4a52949115ab15d2196e44823"

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
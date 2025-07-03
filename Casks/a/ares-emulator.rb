cask "ares-emulator" do
  version "144"
  sha256 "ca7d6b9d7bc4a342c6b0dbfb85b6d1f30872321bc92906a41c3c4c744edb56fc"

  url "https:github.comares-emulatoraresreleasesdownloadv#{version}ares-macos-universal.zip",
      verified: "github.comares-emulatorares"
  name "ares"
  desc "Cross-platform, multi-system emulator, focusing on accuracy and preservation"
  homepage "https:ares-emu.net"

  depends_on macos: ">= :catalina"

  app "ares-v#{version}ares.app"

  zap trash: [
    "~LibraryApplication Supportares",
    "~LibraryPreferencesdev.ares.ares.plist",
    "~LibrarySaved Application Statedev.ares.ares.savedState",
  ]
end
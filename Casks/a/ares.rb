cask "ares" do
  version "143"
  sha256 "116b24b94d1ed4af28900b681d202b5843358d67f49d0ff97f4f9dbd238abe53"

  url "https:github.comares-emulatoraresreleasesdownloadv#{version}ares-macos-universal.zip",
      verified: "github.comares-emulatorares"
  name "ares"
  desc "Cross-platform, multi-system emulator, focusing on accuracy and preservation"
  homepage "https:ares-emu.net"

  depends_on macos: ">= :high_sierra"

  app "ares-v#{version}ares.app"

  zap trash: [
    "~LibraryApplication Supportares",
    "~LibrarySaved Application Statedev.ares.ares.savedState",
  ]
end
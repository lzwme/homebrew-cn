cask "ares" do
  version "141"
  sha256 "e5fca2c32c10c86125062d3740ff8188bb362233e289296770ee1efc80305ecd"

  url "https:github.comares-emulatoraresreleasesdownloadv#{version}ares-macos-latest.zip",
      verified: "github.comares-emulatorares"
  name "ares"
  desc "Cross-platform, multi-system emulator, focusing on accuracy and preservation"
  homepage "https:ares-emu.net"

  livecheck do
    url :homepage
    regex(ares\sv?(\d+(?:\.?\d+)+)i)
  end

  depends_on macos: ">= :el_capitan"

  app "ares-v#{version}ares.app"

  zap trash: [
    "~LibraryApplication Supportares",
    "~LibrarySaved Application Statedev.ares.ares.savedState",
  ]
end
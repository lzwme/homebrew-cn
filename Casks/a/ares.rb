cask "ares" do
  version "139"
  sha256 "8d9021af43b2c2b45ed5086f2d414d39f3f3aef710cff97a61fde657a88b1f9a"

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
cask "ares" do
  version "138"
  sha256 "6ca39e1e2b12bcd11a60ccef79d2300fde421ddc0d853b6841cb877a4909bee0"

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
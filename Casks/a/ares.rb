cask "ares" do
  version "140"
  sha256 "650811f5dbe3c73a2b20ecf92b17093c9ba4bc87611481b549eaeabb3dd31771"

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
cask "ares" do
  version "137"
  sha256 "122789ed8815d7466e4dff7b77e7215e5d9ae6b34d99069743da7e58d0117902"

  url "https:github.comares-emulatoraresreleasesdownloadv#{version}ares-macos.zip",
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
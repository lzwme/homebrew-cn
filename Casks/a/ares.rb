cask "ares" do
  version "136"
  sha256 "292aa03f709eff76abc0522e8f4d52a6a13b8547c8d74ac8205c28be5efd7d2e"

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
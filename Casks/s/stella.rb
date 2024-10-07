cask "stella" do
  version "7.0"
  sha256 "dcd6de1baf5b2fdcf655478eb04d3fb8e65e3cdaed2e04cd6c5347b3149c1eed"

  url "https:github.comstella-emustellareleasesdownload#{version}Stella-#{version}-macos.dmg",
      verified: "github.comstella-emustella"
  name "Stella"
  desc "Multi-platform Atari 2600 Emulator"
  homepage "https:stella-emu.github.io"

  depends_on macos: ">= :big_sur"

  app "Stella.app"

  zap trash: "~LibraryApplication SupportStella"
end
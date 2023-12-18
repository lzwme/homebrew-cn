cask "stella" do
  version "6.7"
  sha256 "c4dbe867738c244d0f00e4b13b432dca305559fc36ef1614f749291c805e5003"

  url "https:github.comstella-emustellareleasesdownload#{version}Stella-#{version}-macos.dmg",
      verified: "github.comstella-emustella"
  name "Stella"
  desc "Multi-platform Atari 2600 Emulator"
  homepage "https:stella-emu.github.io"

  app "Stella.app"
end
class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://ghfast.top/https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.15.tar.gz"
  sha256 "62730610a75c5108ac26ec895daa5d1611ff1127b972ee97c17fdd80ececca03"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "02246d8ca65642b8e9f6a35afe7c2c1af3f3e877e54bf48c996cae9941d92a10"
    sha256 arm64_sequoia: "4250d433d6696b457189f82dc7a5f2f1b819daff9a4c9ce7c0547a7539410dc7"
    sha256 arm64_sonoma:  "79ddc47ecf6bb7a7b792063e1154b6e5928f0aaf72a026a834dc0d2fbaf22968"
    sha256 sonoma:        "98c83eb3473e6d88ac2880a6afe7e0d3bedc1a84ad0e364e72447b3abff0cab1"
    sha256 arm64_linux:   "1671c59d1931778d330bacfedbd8bcd17aa5e3d551685190d6ea747d9d6fe86c"
    sha256 x86_64_linux:  "cf84fdb5afeed507cef7d28ab653d866831e1dccf2fff2e8c41ef909305fa994"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  def install
    # Use HOMEBREW_PREFIX path to get sdl2_image headers
    sdl_config = HOMEBREW_PREFIX/"bin/sdl2-config"

    system "make", "bin/brogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}", "SDL_CONFIG=#{sdl_config}"
    libexec.install "bin/brogue", "bin/keymap.txt", "bin/assets"

    # Use var directory to save highscores and replay files across upgrades
    (var/"brogue").mkpath
    (bin/"brogue").write <<~SHELL
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    SHELL
  end

  test do
    system bin/"brogue", "--version"
  end
end
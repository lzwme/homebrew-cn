class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20251221-git-b6673bf.tar.gz"
  version "0.3a-20251221-git-b6673bf"
  sha256 "eb83902db2fd00ece5623028471981fb35daa0e062de2690f22212d277af989f"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ece260dcd0009ff9e511301d0e4497cd741cffc5a947c726116a61a3f577d05"
    sha256 cellar: :any,                 arm64_sequoia: "6fa8746392c64a515cf1541fac4f9b16894067cb94e5b294f61fb49984030621"
    sha256 cellar: :any,                 arm64_sonoma:  "a5a43d00b2c292ebe9d1fe06779d2b047613e6980d3eb1363bb2b43ae4c3a22b"
    sha256 cellar: :any,                 sonoma:        "1beaab56bf3c506b4f2cc7732c0c29625d5956cac15059434ab89922533356ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78ed1d1d7201dcb66fdaf83d947540da4647809396ea7f3a9b20af6a761654d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc652318a5071f049f85b30160516809f71aa040186ccd4906712534366202ef"
  end

  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = "Makefiles/Makefile.#{os}"

    ENV.deparallelize
    # Set up SDL2 library correctly
    inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?

    system "make", "-f", makefile_dir
    bin.install "bin/supermodel"

    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
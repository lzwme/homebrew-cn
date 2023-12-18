class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https:angband.github.ioangband"
  url "https:github.comangbandangbandreleasesdownload4.2.5Angband-4.2.5.tar.gz"
  sha256 "c4cacbdf28f726fcb1a0b30b8763100fb06f88dbb570e955232e41d83e0718a6"
  license "GPL-2.0-only"
  head "https:github.comangbandangband.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_ventura:  "c7501052965e907fd7a088f4e5fbe06c0a89f7064f96965bbe6f1637cb83387d"
    sha256 arm64_monterey: "2e614515be3541395fcc42067c4e5174157c51a27d35645cd6798be7d0a45f83"
    sha256 arm64_big_sur:  "4ebb2cc5ce335cc1760a5225733a8dd55594d332be9330fa60d8d7877c34732e"
    sha256 ventura:        "808d10e9cc163ef98847717e263ed262228d53cc2034b17c8a7510e8feb3992d"
    sha256 monterey:       "b99c56e6324749ead8f874ef8b1c9a795042190849f0d3a21be96eca60558fe0"
    sha256 big_sur:        "f96fbff60ba98dbdb462fdca56ee7b4891737afc7cc90451432cafc8a727d516"
    sha256 x86_64_linux:   "cdf766e08ed71a08dab5b873333ef14bb4ed7918a55601a35106b4dbb717538f"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}usrbinncurses5.4-config" if OS.mac?
    args = %W[
      --prefix=#{prefix}
      --bindir=#{bin}
      --libdir=#{libexec}
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    args << "--with-ncurses-prefix=#{MacOS.sdk_path}usr" if OS.mac?
    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    script = (testpath"script.exp")
    script.write <<~EOS
      #!usrbinexpect -f
      set timeout 10
      spawn angband
      sleep 2
      send -- "\x18"
      sleep 2
      send -- "\x18"
      expect eof
    EOS
    system "expect", "-f", "script.exp"
  end
end
class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lame/lame/3.101/lame-3.101.tar.gz"
  sha256 "7578af6eebd578b2bd64e468fac4ae1f03670a7e028166e67f855674b9b6aeac"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/lame[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b1b1d99080d3ba7a3a2a188df7f4497b94e1d9295b6864cebe69b3592bf53cca"
    sha256 cellar: :any, arm64_sequoia: "f9bcb2827f360fb78ba0c322bae06fcfad258a17bb3ce15691896b79676c2cfe"
    sha256 cellar: :any, arm64_sonoma:  "0162c94e4c71bf08eccacd4880c986cb238cf5c2bb1dd2e897afc64462733966"
    sha256 cellar: :any, sonoma:        "d8f4d8c577cab80f8156c4be7010d88f0e6ebc61307d8e67f4d4a704b1136561"
    sha256 cellar: :any, arm64_linux:   "5f8e0cf608568b4b6059205b85ad47aa7034bd249f0eec197641711712d669f0"
    sha256 cellar: :any, x86_64_linux:  "8dd427008a1fafaad992f7648c14f890921a71fde621d3ca94149cd9d2866e97"
  end

  depends_on "pkgconf" => :build
  depends_on "mpg123"

  uses_from_macos "ncurses"

  def install
    # lame.h leaves id3tag ucs2 helpers parse.c calls undeclared, but they are still exported
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system bin/"lame", "--genre-list", test_fixtures("test.mp3")
  end
end
class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http:0ldsk00l.canestopia"
  url "https:github.com0ldsk00lnestopiaarchiverefstags1.52.1.tar.gz"
  sha256 "c9c0bce673eb3b625b538b462e49c00ed1ee1ded1e0bad09be780076880968b5"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.com0ldsk00lnestopia.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "67af1d1abc8403e93fd13196f700615e07dd7034479f3822f1a4b00b1240899b"
    sha256 arm64_sonoma:  "6c6067d902336e6e8ec57e70607c703b6a4d95e8639cde05375b667da2b2f97f"
    sha256 arm64_ventura: "c57ba97017d1bed91703be29ff24a3cccf099fc962e0972e63c9af9c8ea54083"
    sha256 sonoma:        "9c90b0b5a87130d6d4a64e37c76f9d358e238a9a87c5bf227448f0bd143dd8b7"
    sha256 ventura:       "b0900fc15e84459bd860ec7ea552d9abebf8670dc3211440d9e585706d72cfc4"
    sha256 x86_64_linux:  "9108695ba978f4218da904110ce3d22e0345aeb85edc7bc3152997e759af58a6"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fltk"
  depends_on "libarchive"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-silent-rules",
                          "--datarootdir=#{pkgshare}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Nestopia UE #{version}", shell_output("#{bin}nestopia --version")
  end
end
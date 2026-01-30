class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.10.tar.gz"
  sha256 "9ac047f9a4b402722a697062680cdc8fe4a9232da58de0976d7424a79208ad98"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fd11285ef48f542ac28ba46b8ec8a352f26b6be09f320f8fed35485fb54fdd39"
    sha256 arm64_sequoia: "dd4d64ab03f22d137aa88677c76a656db0325676cdc20419dd046b758cd646d6"
    sha256 arm64_sonoma:  "1c835a3fd16d477303ccff4462489b45471267c540d51b300331deab71922e86"
    sha256 sonoma:        "1bac6c897fe5e7e666eb44b83ff674ced4fd63a10d7c0f6b98656b3615855613"
    sha256 arm64_linux:   "2e9a1e3257efef5c3216dd147028e4a68bcabdd40fef00e3b97daf815f14525e"
    sha256 x86_64_linux:  "d4844b7624bf77cdeefb6143c09e0bea626e273a86fde23667e083f73b1c597d"
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari",
                          *std_configure_args
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
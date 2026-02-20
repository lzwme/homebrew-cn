class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.30/xapian-omega-1.4.30.tar.xz"
  sha256 "b3faf202efd11ab6eb749bdd47f639b3dedc781eb0d579edafc80cd1340a461d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "803f81e690028cf1de1902b9cbf954ac74e6f3a37c233b434fd0881566c34747"
    sha256 arm64_sequoia: "28fe15440fa53256606bdb030327d28f2775b14bf919a7352cb593e98c92b3dd"
    sha256 arm64_sonoma:  "440ec8353cd04731afa0cf87d51293a41f69e69a47ab66696131117fe5bb2c67"
    sha256 sonoma:        "6e1a3fa8ff0443306b714b94116c44e6cfa4abc7f73bf73671bbfe6a7c58a7a8"
    sha256 arm64_linux:   "b86d3b158214226ae5821c64b05e7f7e5909fe66bf983219fc1254fd5c6ad30b"
    sha256 x86_64_linux:  "79ae5a5c21480dada9df6b412f5b7c8fecce5e43568223c7f32cede95aeb24b4"
  end

  depends_on "pkgconf" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_path_exists testpath/"./test/flintlock"
  end
end
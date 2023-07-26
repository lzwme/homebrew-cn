class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-2.0.0.tar.gz"
  sha256 "176705f1de58ab7c1eebbf5c6de46ab76fcd8b856508dbd28f5648f7c6e1a7f0"

  livecheck do
    url :homepage
    regex(%r{current version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fbeb7ff7273a9e9a26eccbbc4d9943167645de04654f5ada57b399262a66eb9"
    sha256 cellar: :any,                 arm64_monterey: "d5b5f5091fde8145fb4854df71e5a0d4c85064983f0ff50e8649b66e72459436"
    sha256 cellar: :any,                 arm64_big_sur:  "65496307a6328795f5a4eaeac73e715d3b10852538476a37b141c69500db205b"
    sha256 cellar: :any,                 ventura:        "deffaa3f557b73b8bfe491a641ed7bb0727bd8b8f6d81cbb8795f530e7db2624"
    sha256 cellar: :any,                 monterey:       "3578de5c3c6d52a04ee32fad357d1c4f25ee62a8d2a05dbf21fbe5e5e3595620"
    sha256 cellar: :any,                 big_sur:        "915b680af0a7f34c12f86630fe22ac48b479fc14e24df6a4fb2c9274b0a971d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a23aa6cd549e49b7d3d3f5bf160d97d1125c26587074580b2926060003269e9"
  end

  depends_on "doxygen" => :build
  depends_on "minizip"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check"
    system "make", "install"

    system "doxygen"
    doc.install "html"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "freexl.h"

      int main()
      {
          printf("%s", freexl_version());
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfreexl", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
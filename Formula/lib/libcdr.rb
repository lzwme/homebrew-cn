class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 6

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "828104e9ac0396fada40357eaf5da22f3137ee7cb91eba91ad7bd1661f7428f9"
    sha256 cellar: :any,                 arm64_sonoma:   "b4324147de4d9b3a82e0ae4239bd1306cb5e5b01d52c49e137d8002fd9999fa8"
    sha256 cellar: :any,                 arm64_ventura:  "588bbde423941f0353de8d1079e317732c576af3b0a661aec50c83352a9047c7"
    sha256 cellar: :any,                 arm64_monterey: "7a30b587bbba798295a3af16acff7d9974ec298d0e3b7b2f1fd92f249b140e09"
    sha256 cellar: :any,                 sonoma:         "644cf0326dbf7d581058607b31f042e279ca25399f21d718b4d1685aa7af8017"
    sha256 cellar: :any,                 ventura:        "f8ee293a246acd9b49b89191d8261670752a11361b536140554f7453b086e563"
    sha256 cellar: :any,                 monterey:       "f2c5dc565e10c04952c7a9aa9233c03b10b03105b67e31150766838a10281c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8b063489f3ba6c851e69c3c6dd2677c1a1cdfea605c386507bb81840a4b74c"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-tests",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
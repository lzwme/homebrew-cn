class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 9

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "87ac7f5c6b255fba3d53c09d49938f45ea373a7aaa12c8ab865ec690cafdf00b"
    sha256 cellar: :any,                 arm64_sonoma:   "9bfe32f374fdb4df86bf8ebc699f3aa29812590301e9cf081b2bb84b0b99467b"
    sha256 cellar: :any,                 arm64_ventura:  "e0c7e7d053872d13fb45dbab46fa56f56da4c1870102af9f099be704abfbed85"
    sha256 cellar: :any,                 arm64_monterey: "35c16739c618799fba69e03d20f12721acfeb83dde4145cde6858d18c787c71a"
    sha256 cellar: :any,                 sonoma:         "1b2b6787013e9a518bb237c218d860e229c8b3469d7a1770ced6d94d1ee8d170"
    sha256 cellar: :any,                 ventura:        "2963b1b99018b111a783072a9d6abd0a02fe229e22a25d3c8ba0f6265069831a"
    sha256 cellar: :any,                 monterey:       "b253cdf2cecb4346c3f09299e2e4231fede1f68b16bcf4ae81402e2cf0204875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0959a2cb94e549f664c6279543101f1a53840892c0155cb3a734cc03f552feb6"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-tests",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
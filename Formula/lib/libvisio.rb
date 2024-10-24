class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.8.tar.xz"
  sha256 "b4098ffbf4dcb9e71213fa0acddbd928f27bed30db2d80234813b15d53d0405b"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f884941e46d24f5876b22335b23a5e47b281e9d247f0985abcfcb696b541632"
    sha256 cellar: :any,                 arm64_sonoma:  "39996bb979bce409ea8f627ec91631639b2983088321151be65682eeae68cc60"
    sha256 cellar: :any,                 arm64_ventura: "d4a544d287a4efbc6a0e64feab31c88ebcdde01638e2be00af3b31435caf861b"
    sha256 cellar: :any,                 sonoma:        "841ccde30a15eaee84f5a0da8446e76a7e47e9de6647fea95a940ec884ae8048"
    sha256 cellar: :any,                 ventura:       "02401c43b58709247512e961611253c56f84e574d75983d71b80724eb18e90f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e26c35ccc5e22ce9cce7fcf009c0c9c31a3f44348af3b3655d854d7b7e1726c"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  def install
    # icu4c 75+ needs C++17
    ENV.append "CXXFLAGS", "-std=gnu++17"

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
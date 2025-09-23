class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.9.tar.xz"
  sha256 "4a61d086daa3f5c9db8a3fd1b6dbfc29ba756057aa6b3cc23878fd4854362af9"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6ad5516ab379653ef1db51d000c0912dd102198b918370884fad400e2391dc9"
    sha256 cellar: :any,                 arm64_sequoia: "f1b4c41baf1cc4f4bf816ebef08e4543999dd4f184e1f58fab4ee9a9108be417"
    sha256 cellar: :any,                 arm64_sonoma:  "1ddc8008522e26ec0ca37830d794b4cce3816eeffba5f6e97731c1cc3da59519"
    sha256 cellar: :any,                 sonoma:        "14f07090c4e4177c274d520e2a809d0fab5bbd5ba072bf7006ece876b699397d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14cd13048d1ca649d8f1074de0fdadbf37c877ec93633b9bfad77b6a9489edad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44832d4535f3bff59df5a1b80f5e2f3a8377274abf1324149df86001822517fd"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
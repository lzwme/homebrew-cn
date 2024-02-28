class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https:github.comIlyaGrebnovlibsais"
  url "https:github.comIlyaGrebnovlibsaisarchiverefstagsv2.7.5.tar.gz"
  sha256 "613c597b64fb096738d4084e0f2eb3b490aded7295cffc7fb23bdccc30097ebf"
  license "Apache-2.0"
  head "https:github.comIlyaGrebnovlibsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "daad2ec5e6fc5e96425e97878b467f544381de747b80a62d3c69827128cb23da"
    sha256 cellar: :any,                 arm64_ventura:  "c5454babae8e4fa6057842bd46baa79d62ebfa0c4fbbb035cfcc12ba3a9cb36a"
    sha256 cellar: :any,                 arm64_monterey: "e534085a6008bfab3cdb93e84b6f343ba62f2ef2103afafda6b99a9a2bdb0f91"
    sha256 cellar: :any,                 sonoma:         "81cb9d0856c59377d071eb83f64ac593918fad13a634fd4518bd722945c977a8"
    sha256 cellar: :any,                 ventura:        "dc60d1962a22e11e96eea4ffe5e2222471603f13a2c1ed0040661c2f78c94c07"
    sha256 cellar: :any,                 monterey:       "70c800087193270087cc328d4367ebf0753de98e51976ad002f044dc59982bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7955b06de8eacd90e90b284a8d0fa98a6cbdee5cfdb44ad387b475bba42ae8a3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("buildliblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "includelibsais.h"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system ".test"
  end
end
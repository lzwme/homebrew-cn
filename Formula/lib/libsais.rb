class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https:github.comIlyaGrebnovlibsais"
  url "https:github.comIlyaGrebnovlibsaisarchiverefstagsv2.9.0.tar.gz"
  sha256 "eed46bcba3ab3b08fadf11d64c99497f21587b44ba18412042c3e087b658c28a"
  license "Apache-2.0"
  head "https:github.comIlyaGrebnovlibsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19bba27b56a4c890084cbf223e58ef3b14efab3a0c61edd6b025b628317f4a29"
    sha256 cellar: :any,                 arm64_sonoma:  "c5cc957760d690302bde741e4ab8f55c906384c44d09564dcd1c4f7723aecbeb"
    sha256 cellar: :any,                 arm64_ventura: "8a5e36ed28f7410bdc6908100dd7194b298d6784cd99545293879d5426ce7e9f"
    sha256 cellar: :any,                 sonoma:        "51caf063ac38481b690df2d89b3ee2f66a9762f27666b6e3351426cdc41254e3"
    sha256 cellar: :any,                 ventura:       "831d57970132761ab8d3ee5b6bef2dbd7e03cf235a99f41c45dee2743335e02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c199bd76b40ac1e5a2775d5fa739447eee86f38d3ffc3caca932156826e160c3"
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
    (testpath"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system ".test"
  end
end
class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https:github.comIlyaGrebnovlibsais"
  url "https:github.comIlyaGrebnovlibsaisarchiverefstagsv2.8.6.tar.gz"
  sha256 "35a7956bc018534293573c9867a59301e03b793596430ebb0c3531a6db088148"
  license "Apache-2.0"
  head "https:github.comIlyaGrebnovlibsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "774b2a3682dcaa3a7b4f6da95881595bea698298feca4a879a3494d2dcfbdb82"
    sha256 cellar: :any,                 arm64_sonoma:  "015781a9ffbe3fcda6743d1e47dafe47d6c1af349043b79c0b162139c9c148cd"
    sha256 cellar: :any,                 arm64_ventura: "4e880ca04f3f27dd125e327131fc2e139a85c3ef25ff2e9bd04801d70fc9b4ea"
    sha256 cellar: :any,                 sonoma:        "9197910c926a67ca8fb69f680ed41cc9e987cb70868b22bd2e90f55a1f40f818"
    sha256 cellar: :any,                 ventura:       "0330ec56775d6a3a372f13034caf965b0b0cdae5e7819523b9f6aed4a6e19914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97689d9ca62d3f5cee9f5667c079287468b92183f3889a6257514bc25ed93f10"
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
class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https:github.comIlyaGrebnovlibsais"
  url "https:github.comIlyaGrebnovlibsaisarchiverefstagsv2.8.3.tar.gz"
  sha256 "9f407265f7c958da74ee8413ee1d18143e3040c453c1c829b10daaf5d37f7cda"
  license "Apache-2.0"
  head "https:github.comIlyaGrebnovlibsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e413751ce22490ec1f882e894db21bb5ff5bb03bba55c1b0724555abc6a3ec94"
    sha256 cellar: :any,                 arm64_ventura:  "05e570449b9d072a1229ec0f394b8ba0bae429642d0866c30da77051dc0caf3a"
    sha256 cellar: :any,                 arm64_monterey: "2f1f4330f2aff690579f7044afaee58fbd25af0e7be0e4ce151a2d02f1fbe851"
    sha256 cellar: :any,                 sonoma:         "8aeb9a3c99d628b20c44ea143f9793cb4989bfc7d932b6a76a48abf411aa0296"
    sha256 cellar: :any,                 ventura:        "9a00e90dfa7f2508aa3ff985b0e6ab0f85a78361fdc225423f62f573cddaa586"
    sha256 cellar: :any,                 monterey:       "27c9cb047ba20bc510c057be06cd6c02eecf10f5b10208a1b0aa936bc24f3d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9987a6063a1a147047fbd844c5b983df3ea5c47a02eba0a5bee70de1906c1b7"
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
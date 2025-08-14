class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://ghfast.top/https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "69cb3ce4982ac0f6228cab4f5b324dc2445f82bb260ad8c927aea8033c661d52"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd23c5fcb60fd18ceeb2f97e4582c91317351a99a197b9e32b1b8b92c7263a93"
    sha256 cellar: :any,                 arm64_sonoma:  "f4e8061357a69512c1dbc4bfe6f5b9c98883bc4fa6022e3d3e4d10207a56b95d"
    sha256 cellar: :any,                 arm64_ventura: "b620a8a59d79f2ec8cd801721428fb7dd0ab310a77a903f86a90827f39569b96"
    sha256 cellar: :any,                 sonoma:        "c418b7d5ad9dac2438b72673d6d0f5a31e47b5bfd3709812b7bdee4ede104121"
    sha256 cellar: :any,                 ventura:       "d174fcaeda67aaf4b459da8a2f536c69175837cb239d93bef902dc68c2fcfe17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a3ae5eb5bf5edc21def4ec4646094e10ff99db7782f96c9bfd5b7d116929f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c4c7947ef3a3755205802a097a539de22e0d8ce597bf1dddb43f50c152d775"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLIBSAIS_BUILD_SHARED_LIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system "./test"
  end
end
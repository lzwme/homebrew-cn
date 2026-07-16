class Libunicode < Formula
  desc "Modern C++20 Unicode library"
  homepage "https://github.com/contour-terminal/libunicode"
  url "https://ghfast.top/https://github.com/contour-terminal/libunicode/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b77df7cf2ae61ac22a94e6f7e112e4941bfe785dee1ef37e17851c13872aabc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b5e663abf6f8c8f51fbcf3cd6ec5abaeddaa73e2b8e2eb374fd6ad5719df8ec"
    sha256 cellar: :any, arm64_sequoia: "65644f9a15bc8be32ef0af3a4ef87674e29b1d51ee4a382b3a704efb6f568b42"
    sha256 cellar: :any, arm64_sonoma:  "8d2d39bbd2dac2d00a2ca139c5ac5e8cd2b6849129f7786c7d946a89cf36ab71"
    sha256 cellar: :any, sonoma:        "77740649c5c2ff577742393b778a5ef5149f587135a2e2155580145b5dfaf5cd"
    sha256 cellar: :any, arm64_linux:   "bc0be008d7aeec6920239ad01ff52c2a4b566152096f980991b855a83f66c0a8"
    sha256 cellar: :any, x86_64_linux:  "ad2c70d2a97a2f6137ff89c66687f3a7f8a7141619abdb68f29beff2519c45ca"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DLIBUNICODE_EXAMPLES=OFF
      -DLIBUNICODE_TESTING=OFF
      -DLIBUNICODE_BENCHMARK=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <libunicode/capi.h>

      int main() {
          u32_char_t u32_codepoints[] = { 'h', 'e', 'l', 'l', 'o', ' ', 0x1F30D };
          int gc_count = u32_gc_count(u32_codepoints, 7);
          std::cout << "Grapheme cluster count: " << gc_count << "\\n";

          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lunicode"
    assert_match "Grapheme cluster count: 7", shell_output("./test")

    assert_match "HYPHEN", shell_output("#{bin}/unicode-query U+2D")
  end
end
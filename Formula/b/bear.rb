class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "81a04856aa9c49154e910cc8c30fe77740e825179527b9f400be6e5705e5c16f"
    sha256 arm64_sonoma:  "2291170c1f80560412ed97dc1210c16e8e997a88cb728c732f098521e5f37b3a"
    sha256 arm64_ventura: "ee9c53959b0a913a63f0879a0d01020a1e8a465dd792eba1657d55073a22d108"
    sha256 sonoma:        "860fe7ea4e0e1a88990b1ae3da89207e5a41c6c6bc3080c573aa3688b1ebe54d"
    sha256 ventura:       "e26247c3de49d66c56fac2c46950ea1491fbb654a0372c20bfbcb975d1121f60"
    sha256 x86_64_linux:  "819c72744ef8d13b150ca76db7d296e3e7cb5a7aa23f15338334af47c07c37ef"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin"bear", "--", "clang", "test.c"
    assert_path_exists testpath"compile_commands.json"
  end
end
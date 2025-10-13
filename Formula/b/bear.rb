class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "42d47f5f6575a81d22b37dce8d59ba73a481406e1b44f7e31e7ee00d88f5401c"
    sha256 arm64_sequoia: "b80eaacbdfe39935ee09b4e772f0cd89a6293712d9538850da7e63b571bee65f"
    sha256 arm64_sonoma:  "4a1188563d85c6c21605b642ee9a9b11dd89f957e5802b527c05b98d256377e5"
    sha256 sonoma:        "203c65461d9f263fcaa9c0f85ee28585acc312f8b87f537cc37d2ab4cf503c55"
    sha256 arm64_linux:   "fec15bc14de29ac61ff2e9c91393fe1617f626fa082e707080cde2a681f4912b"
    sha256 x86_64_linux:  "5295d5476638577ef82d71bce089c6c094f6b63a346061df8ae655c7683a145a"
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
    cause <<~EOS
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
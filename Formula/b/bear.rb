class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 13
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "eed336692e1b142d99fa42eb02039276bfee17fae510ff8b3991ea909ca0c9a1"
    sha256 arm64_sequoia: "1a0362dba17bddffaa1904592fee8e17d6da4a14d6abec690a177559195f6247"
    sha256 arm64_sonoma:  "0d16aa42a9c6d3a972770c32d1bfd4e58be7b3d747033353e217befba257b6e1"
    sha256 sonoma:        "0368697645ec4733cef9b62925a3dc170fa1c28986702a63a84ca4b9b054bb07"
    sha256 arm64_linux:   "47a892cfcbd94dfb5b553e5acb4741fc20f4a5ad22582c152e4e05454db21a7c"
    sha256 x86_64_linux:  "1084d51e793d662b799db8704d94161108bda1f60c82a9144b949529a43cd9cf"
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
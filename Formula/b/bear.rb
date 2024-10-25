class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 3
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "c057ba2bd307d69afeb6ef8b0931fa93f67a6bf7fa60b7ac0eb64ea31c2e20da"
    sha256 arm64_sonoma:  "40eb873ae7aee68443b02b643c5d18b1fe56d87e8d85c6d2e72618879fcc92c1"
    sha256 arm64_ventura: "2e90f0eda00ec07b9d53ffc1557b0ac5bb8d79dd3aef0edcf0c84737a83b68b3"
    sha256 sonoma:        "1351a56c8b15552957ba98fb0b7c3048d68980f7ef890eaeecffc62456a8e0de"
    sha256 ventura:       "9b0559237fb47ae1f16469370c7d288c735d6e1bf344cbe74b4b3724b6dfb727"
    sha256 x86_64_linux:  "53ce9f3e2d4019eb7f4e407b39c4900077fba3c2668b6cd3b6c43d561b6f74d1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5" # needs C++17

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
    assert_predicate testpath"compile_commands.json", :exist?
  end
end
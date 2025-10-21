class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 12
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "54b668bd1653313068f27b1b9e426bac028804fc3fda1e094b0beccd96f18a88"
    sha256 arm64_sequoia: "f7fe14049f8c1dbeaa6a1a74690eca06f8b70a32550628c1928a4091c3ce11cd"
    sha256 arm64_sonoma:  "acd64db83e9dea5034b52d5698995e8f49621f23ac6d7b3ce66ffaa9dd200a49"
    sha256 sonoma:        "d518b408cad03fd7edb9653073abddfe2cae2d10d8901b16014c91e38d635824"
    sha256 arm64_linux:   "6cc9a11117eeef27abdfaec7991bdd3f3a9b0185609cc558f5e783f2006e82c2"
    sha256 x86_64_linux:  "7f1946cb902291f6a1871c186a1ebfe8918d0f90d22281b2f82a2a123837744b"
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
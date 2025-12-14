class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 15
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "f7b1e00ac4c2948a24c54955d254938b9a3ae8af47a477df4bb6badae9f14f39"
    sha256 arm64_sequoia: "121bcd357125ab7002a4cbb8411e9ff6b2ce9ecc1a359e69ed37c601205a48d9"
    sha256 arm64_sonoma:  "5ef89d2d97ef43dacfb7d3e439eeb4fdf1f1adc9d13e19a2dc0ba5c4571f4371"
    sha256 sonoma:        "c0aed585dbbceb78a37af319bd74be9c58a9de6eb59e79d8c7d8d72d5b22d7eb"
    sha256 arm64_linux:   "edd556206477844c1555d63a5d976ef7ad29ecc3c3e3f2980958fb84de534cd5"
    sha256 x86_64_linux:  "0489f2c3ba1362f7858dfa31c3e79ce65c073fc268cea0d9bd9ee6d5e3cde8b3"
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
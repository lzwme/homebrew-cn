class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b179848c77449e83cee35a5bb69fa9e894adef018cda5a5a20658f87370551b4"
    sha256 arm64_sonoma:  "e3644a8528081489f80a2500e9b1a82b5c90e3a2e348bae71fc45d7973f5a75c"
    sha256 arm64_ventura: "da92116f542d2c2296193bc8e4d3e0f1d550b9b864f97f3b0fa781d7f97846ad"
    sha256 sonoma:        "6fe72a22106db752b1518d907c5f103db4abcba46b578cc5222e9381eff8a6ae"
    sha256 ventura:       "1410d0dd4941599920e78cc29b5b79247beb23d2ba3b81d97bed3a80c39e2382"
    sha256 arm64_linux:   "9db4742cab53f5ac5fb01852ce540cd68fcf41fb6aa90e8f91d2ef87f3fef73d"
    sha256 x86_64_linux:  "7a70d84600b5d9770b465dc129d9548ed60b76d11c22c0ddc60123fddc14f2f6"
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
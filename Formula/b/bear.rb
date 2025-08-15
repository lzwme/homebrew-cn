class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "fde9237ad8a307fdf54158b9ff8433a593d1354e6fbb93e85289761d0c4ab617"
    sha256 arm64_sonoma:  "aec1ed49c543f36a9eeaf4854348c5bf26350841c93c2d7e9ee5c6659a0c20d5"
    sha256 arm64_ventura: "d84312daf9b4681dbe277b40a1db82e2dee5e711b4de22caca5a753f32146163"
    sha256 sonoma:        "139eff0a40feb5fda9db767c898edaaa77172225ab60d0ed163f8a86102e9f9f"
    sha256 ventura:       "6f8548c4df73c362b769feb556100b37a9e0a86c2571f3d80fc796e7e93fcd9e"
    sha256 arm64_linux:   "9e8ad28d9879ad08d127fb9129b5b59c8fa6370a4a482318995f9f84950228e8"
    sha256 x86_64_linux:  "0f9baaa9e7d82ae29fe132bfaab29ffa5c13c8361962f923d30e3dbec28c3a3e"
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
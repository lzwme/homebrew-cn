class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "017f626ea77796ae03a10707c3c66d88b56ad8d49800a706074cc97addac23fe"
    sha256 arm64_sonoma:  "71f28d103231964601fbedf02f7886a2ffa2e120bb13b0ae003ab9d2cdc14f2f"
    sha256 arm64_ventura: "64897d2c5c0d5a919d97ca87e1311f873287ce8a5f9731502278dfa169b06761"
    sha256 sonoma:        "3a5dcdd3f344cab3b46e38bf56a919c1c34fc4e7ad1d2de44be88315d827aacd"
    sha256 ventura:       "371de8e1ed177026483052628f7c8ad5dc6542e6b984cfed7e71d5e163dfb835"
    sha256 arm64_linux:   "054dcde82d614c499a8b2c65247f176b155e8798dcc8890965409e3edf95c12e"
    sha256 x86_64_linux:  "c511a17977285fc5a7bd7ee0321a800f116a93b6fdeda3a99a7a53c1a7fb107f"
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
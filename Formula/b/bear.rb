class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7c9ac53537b8ce0affdba8c6a0f6b2855ceff3a2b21817d33c254c1fb9506f39"
    sha256 arm64_ventura:  "a1db76fbcd40f33be2ca2b460ac33d074981e4fca833f47f7be9f9c39af8ca03"
    sha256 arm64_monterey: "80fd09740da980ffa4c4942801ce4a6d0c435515c9ff60bc96403cc8f4b18074"
    sha256 sonoma:         "4560e584471cf38732032277e0bfe7759636f47efa39cf86d14952b86b092a37"
    sha256 ventura:        "6b8b956edb4aeb42df0a22b51839bf43917ce1beabeead9f23ec84247075b53f"
    sha256 monterey:       "d9bc3f4c4474ca983994fac698ffd71713b9fec0887d842b16023f1a5e5c6a1b"
    sha256 x86_64_linux:   "8de6dfcecaf61a3d4be6572f2be9e279c970179d547880a39d9a23ddbd7c8a11"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
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
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
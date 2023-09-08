class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "11ce0854d66302f50e136c919e7eeefb0284a356e9644cb03d5999fde4b52205"
    sha256 arm64_monterey: "8c5c3514fbfc58c6d1cf7e33ed3ce7e66c2a04da1b9143464a36e5c2f63ac567"
    sha256 arm64_big_sur:  "91190698a637465e8d7690b9999314aad798a363e8e3d64d7ee4b6f405489e1d"
    sha256 ventura:        "262dbaa2b8d75736cc3b48d30fefed73e1b924b21275e8dbd6e00879dc9100da"
    sha256 monterey:       "319d713bba49eb49b4099ab0097bfe437143e528cc699d016012e4fe8c30d31e"
    sha256 big_sur:        "99bbd1e086fffae221ecee4f0de1a1ab662123c213756f98657d1984323ed789"
    sha256 x86_64_linux:   "c6e1ac2f796675e0e3c1aa941af496cbbced73f84be670e0b2c7c4878ea76645"
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "2fc142070d7051a148db7c0a0f34f60b47c0d6d2cab89198860c57cc64e328e6"
    sha256 arm64_ventura:  "65235e8ceea7020200047853e5cc1f54610b567020636f926fe05673bdb0d8dc"
    sha256 arm64_monterey: "fd8bf12fdaf487cb3ed5a69e2689b9bf4badefcc8f18ac50984aa0139ebb6b14"
    sha256 sonoma:         "e40a0e7e77f39301f97154a04afcda0bafcb5f3b6441df3faa33de9b054a7998"
    sha256 ventura:        "5bf51ef586b069e524d6b886b5e740519aa3c38aeced1ce4e2b3f59dc216a90b"
    sha256 monterey:       "71a203c10098ca5f6ed76dec0ce1ed09b925200238c3cc246f2ab6870343eb94"
    sha256 x86_64_linux:   "7b6f94d16e30af92517e7cf63024563f8ba2d0d669cfc63ef5288c8d8d56687e"
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a9852517bc86ff7855367016dcd9fb7821ef80d39c34b6fa5428f361e4dd59a2"
    sha256 arm64_monterey: "e849455f24ddc7c1d51fdc9765ece30af244067236565fd99912558f81b91e15"
    sha256 arm64_big_sur:  "68939ef65d5237d4d05a5c1947708664e29a681a49fc388b187c37655d95f5c9"
    sha256 ventura:        "6a7a80fcf1ded12563aa114d66ef10ec23d4a2e215306772d767c551bcee906e"
    sha256 monterey:       "fbde8c672ff51a51d2db7e22f677491539357ab6c2d11b1716fc8dd63415c9c5"
    sha256 big_sur:        "3631d964bf49a5839a2a7fe39334dc207b95338f858748809220cf3dac53c85e"
    sha256 x86_64_linux:   "07ca566929ab5ccb21660f4c5e43938a1d3d5f657ce83feb723b5cde85ab7228"
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
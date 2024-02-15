class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 12
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f9b5f5f109bdcc9e2c100d42a081ea82925b54c77f6ae41f6494d75ceaceee78"
    sha256 arm64_ventura:  "c76c4d4e015c39e0adedc5eb2724b48656133aaf61192b38b731a6c2336edc02"
    sha256 arm64_monterey: "f837d940970082f8194d1f9bdfdddd9c55600ebee7e13bae28438c4ec8116a6c"
    sha256 sonoma:         "4a286f524297f669a446fe3ca66585d9d1246d6120612f519e96646b2ab22a1b"
    sha256 ventura:        "0b39920a6e49828600a12cced723343fe20f37d38da6ccae73a778d9eba8ced5"
    sha256 monterey:       "02b1f04f9154fa8a985c787b482a3c01e9f17066d4c6f41fef767d65d72dd4a6"
    sha256 x86_64_linux:   "2a3ec618b73ebfdef78f2287fc05672e40274516ec7e8a2339ed23a272c1c7d8"
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
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin"bear", "--", "clang", "test.c"
    assert_predicate testpath"compile_commands.json", :exist?
  end
end
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 10
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b5133ce12480e31fea7f4db05c8c522f9eb5c9db66961adab1e304f4866c2fd9"
    sha256 arm64_ventura:  "ee2afaf20488f9c1908434994190ebd48b1463feea8234e4e9fbfce2d190c843"
    sha256 arm64_monterey: "81f0ca4dd0ac38c14db3b23027d810b17aa47d6b28cd765b0ee541a35a59b745"
    sha256 sonoma:         "b62ac874984fe00097e0304ebd99842e5b5b94a9a0cd6a420152d44acb262532"
    sha256 ventura:        "0071170e2b807b46573dc1e49c907cda412a16c4ad243349fd495a9fbdb3047f"
    sha256 monterey:       "5488bc694884479e58e9099f82f3a84c10db2e18205d596462554bf92c8a8c97"
    sha256 x86_64_linux:   "782a37ead75be42d1d23c9081d7ba1da476a961a5aec4de29a9200434805d7a8"
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "2293e9469b83666d37abf4389368d860b461dfad9d18fbba10094787f5b591df"
    sha256 arm64_ventura:  "4c5bb9263e570477910ffa174f4369a9f8140a2277d4727cce4e68b6c7a3df21"
    sha256 arm64_monterey: "ed752c0b0f6cc7c0bb67061d15eea41d2fe4ad04d743780989d6e98f4da08cb2"
    sha256 sonoma:         "78a8b9120dfddf0e650289ed9a1743f383897190cf154a3b95e2468d6be7952b"
    sha256 ventura:        "ccc95dff9db5620b23b3ae1e0fe05af6ff86eb2d280b7488ad15280d5b3152ad"
    sha256 monterey:       "7a596541a884858b3b47c4d6e425cdba20c93966aff76c4cba33c15085999320"
    sha256 x86_64_linux:   "47499c3192ef92fe0ff4ac00776998619a75415b9e41bd2ff484b6a763abeec6"
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
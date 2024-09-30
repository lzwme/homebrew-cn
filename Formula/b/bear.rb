class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "7ccfb02b43d15505668bdaf0fa7b63fb49c3a9980bfbd791c567e87319e91ae0"
    sha256 arm64_sonoma:  "838b2e4de8b5257c0aa1bebb7517ed0afd19cdf972352f0ab2b1837c4934cbb4"
    sha256 arm64_ventura: "0b6b0fe4e63cd36f1e00a5caf7c49214c27ad938e04698583adedd2c4563c6e1"
    sha256 sonoma:        "941247e91b02abd26a26b9ac42ea9d6cc67254162e413d43c0a880d0486d0f87"
    sha256 ventura:       "e2bd7cc5eeb11f435af6e4bbecef0029623504b7217146bb55a25abc466f88e6"
    sha256 x86_64_linux:  "120c76d6e3c728bf9993d43e7656aef61eeb5f12bff9ecede4d23c4baf2d70ff"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
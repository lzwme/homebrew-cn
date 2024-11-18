class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 4
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "39b692860e64000aad16035d9065a059ca76dd9f27f5481817dd66d471ce5236"
    sha256 arm64_sonoma:  "8606d3e3b56248794ab62d5e80a5232e0a78485962cfb2f7842d922c2dcb1fab"
    sha256 arm64_ventura: "57760dd91e783b2b408264eface7c7256cf1e5abd437da22790cfdcf02ede4a2"
    sha256 sonoma:        "76c6096503ad4b818e48f6f1b9a3c3a7f2bd57a3c9589bab74f97777c0164f7e"
    sha256 ventura:       "a9de25613919877cfd76c4003c1d43c8bf913181670c63d91a573f13afb70d9e"
    sha256 x86_64_linux:  "500bea80fa0b33d8ef29392b12503fff859f12b1d3bff4d9658bbf995a44dbd0"
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
    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin"bear", "--", "clang", "test.c"
    assert_path_exists testpath"compile_commands.json"
  end
end
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "191e6f19b2974fcb755023fa9c3de7fd50f0ea7102d924d89b12f497f1c3bbbd"
    sha256 arm64_sonoma:  "745935baffa1fe3eab819766318b44ad7b9e7ccfebed486ecac9c50fdbbfb435"
    sha256 arm64_ventura: "49274e41b436dc8934795ccb943ad04ff231afea4ed8076a84e31c74ffbb273d"
    sha256 sonoma:        "99cf0aa69d3312ed79949e3f3339aa42f035967b358d396a85f66b6fca34a73b"
    sha256 ventura:       "524299345fc222f676de04d26390b8beefd9922a67e8e4d00557593562bd0f9b"
    sha256 x86_64_linux:  "7e900824c6ebd921369518987b9ef731591747a40f297b54c61c7b25fce5d273"
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
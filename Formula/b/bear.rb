class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 8
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "eccfd85452ac9fab71fbc622ca539c216040025073554807687a9caca17631bb"
    sha256 arm64_sonoma:  "cfd2209cf95a04ba5283eb2ae450629e4b5359130b97703c9e29d970c76efdc9"
    sha256 arm64_ventura: "79e9e8aeb39ff18d8aacc1c169454a0d6854b245e734e2807eb008a1b004a226"
    sha256 sonoma:        "58b883c8a97976eeac7be26a9bca3705527f79bf99b05d078ae488c8e44bc861"
    sha256 ventura:       "b5100a1fc82472e5a28182bd5159d3157122bdb8d812c0f9be2e080838788573"
    sha256 x86_64_linux:  "3a59c0e3407f9afebb9c34298ead1d9032a09484800f90a9ae958b6734261028"
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
    cause <<~EOS
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a41100278caf42c7ee21836dbdf251f36fe6753dfde0101fd188fac82a04a1e7"
    sha256 arm64_sequoia: "d145e0ba6b59a23ab54665d57ebcc0d8e051a823d332973b537534f771173ea8"
    sha256 arm64_sonoma:  "bfc7543dd1d24b18a437d05ca45b758ce0a22fcb04c8b864f46e45647bc5708c"
    sha256 sonoma:        "4e9e83e643c57dca9bb758d98dd29e185544a4c3e65986d71b7d932535da95c6"
    sha256 arm64_linux:   "b9b228173c7bbc2abdf5f22f20a941c3ad9f7b659eec32fa975970147090c21d"
    sha256 x86_64_linux:  "cdff03a5733f019811e7c415748f2763636c5c3f2274c89d16723d78ea19c45b"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
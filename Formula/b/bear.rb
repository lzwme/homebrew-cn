class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 11
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "fb122a656345e2674d5d1298b9f007b4750497b3e05d41bd6b206b1be907b3e1"
    sha256 arm64_sequoia: "d19b09e89bc94f76d3f6649fceaba2602a07bccbf94c206bd2af9f5104051219"
    sha256 arm64_sonoma:  "fe4cf6d2fb0352a7de0ab8f222b80118aec7a19f07fa69b37d53783fcad92838"
    sha256 sonoma:        "4c0b32b9463e3c2f644a57be45797566c510a2d0c1782110f3c1996193d9216f"
    sha256 arm64_linux:   "508bc0241678b6fbf2fe3614bf41f6413ac61c13d0949ac5b7079e9b8c1ec1f8"
    sha256 x86_64_linux:  "a1200bb1ab50d5cac856a1d7cdc7f76176889f11d049bd78e750af70aebdf197"
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "cc3e36ab251389b0a7c01f1e7adfd374c6ed66767c0292ceda5df7aaac7b4fe5"
    sha256 arm64_sequoia: "43efc46958f53da89cc962f95e1f43e45bc73ebccbb1f05f55e048f4284e680c"
    sha256 arm64_sonoma:  "5ca5fe464af013fb8eae719e62fea6473ab4b1632e291419d320a3b465cba25a"
    sha256 arm64_ventura: "05675a89ebb562a776ebeb7b2c6a62bf0760068ae764b4232cdc104999bf6d96"
    sha256 sonoma:        "3f86844ccdb75a31ed08564fd2e51c8c8690d38ae544be0ca19bae3f901728ff"
    sha256 ventura:       "97bd05a0799859ca94ffa20cc30cc9327e68fccf3450fb4a09a7e85b2f3a803f"
    sha256 arm64_linux:   "c6df9a2ff4125280aa0741b0ebc1645f214229f697ba8300072baeab782f54f7"
    sha256 x86_64_linux:  "e1d3349175b10d745fb6abfef81248801a68b1c129d672d7e990fd527a4709c1"
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
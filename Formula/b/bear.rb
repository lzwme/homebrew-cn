class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  url "https:github.comrizsottoBeararchiverefstags3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 9
  head "https:github.comrizsottoBear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "6adc021f6c867aa6914507758cf682f53e9d677a4600e4bba4d72403ce9024cd"
    sha256 arm64_sonoma:  "53bc0dda7b3de40d9acfe909a1d46e49c0d683a26a7e93ffa3bc00c32151d749"
    sha256 arm64_ventura: "080d2e9095b9c1a02f361be346cc75647bc6e46c11d331071f3862835acf0966"
    sha256 sonoma:        "9cb5143b4f0dc182f4beafc986e3d55ade00ef3104655a89d5dfa0767c9d92a7"
    sha256 ventura:       "3eebc8d24ec499a4cde76fda6b14d33383957da702a50e251219987be3d451c2"
    sha256 x86_64_linux:  "77a7504882966cb168ca955217b97b9a7d8f01b122b2e44085fd61b70640397c"
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
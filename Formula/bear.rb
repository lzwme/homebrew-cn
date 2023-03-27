class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/3.1.1.tar.gz"
  sha256 "52f8ee68ee490e5f2714eebad9e1288e89c82b9fd7bf756f600cff03de63a119"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "ea2a799c7bc0620e3c2e3aa73689ea2c72864bee679262d1bd65efd8a5827de6"
    sha256 arm64_monterey: "9173cf3d0ca3937bac63e1de44930d5462f945df7abbb2b1e4bc0f319043c761"
    sha256 arm64_big_sur:  "faf7a4509e44d87b4a4c190fdc6559f928abb70909ef04eceb1d54b7e5826d3e"
    sha256 ventura:        "28c919c5841b8181ce5b7bbf0efd1e2c8a4f4c237493258f745a5d90ab6d9d3a"
    sha256 monterey:       "bedc5229a654f3297ff833f3e408b5a07ca38e18e656202c90c9504b86e9ecd1"
    sha256 big_sur:        "a684892e229388b4eeb18a6a8013ca75545a7b3a143508ed89a55629fbe29976"
    sha256 x86_64_linux:   "7723e32a4b15111892243f815bc573e43a1eef3e3f30f3f6d50fa51b86b2c41c"
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
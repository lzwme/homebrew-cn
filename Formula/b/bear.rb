class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghproxy.com/https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "c6f8fd9e69298c7726eecdc0231026c2043d6aa47d157d7ceba45a09ba12505a"
    sha256 arm64_monterey: "4e413a3697e29d7d1ac03b6fb08ea281cae14a067d40d0e311be579b19ea450d"
    sha256 arm64_big_sur:  "d5ba429389988cb2912d74db6e0392804537998d8f927a8622e3da7c6a35a8b9"
    sha256 ventura:        "ae11ca5b00c22afb121f39ea112f6c512c594d7993f6cd70bc0283a67aba4579"
    sha256 monterey:       "ca8f59d5177d8eb45bbebfb6a4199b2a170dfddf143117059e489561577e75c9"
    sha256 big_sur:        "fd8feedc1ba933fc06441a85d3c514e32d9d176762a2585161ca80af3b9053c7"
    sha256 x86_64_linux:   "57667159f433bcb08a959ad6d407389665d653d60d2d135846af5b2a573820c4"
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
class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https:github.comrizsottoBear"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.comrizsottoBear.git", branch: "master"

  stable do
    url "https:github.comrizsottoBeararchiverefstags3.1.4.tar.gz"
    sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"

    # fmt 11 compatibility
    patch do
      url "https:github.comrizsottoBearcommit8afeafe61299c87449023d63336389f159b55808.patch?full_index=1"
      sha256 "40d273a1f1497c2e593fc657a0cdf45831da308c00e3425e5eddb790afceb45f"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "a71e4df765e22c66615e4d5785a0ae97e866a7cd6a1f7d56c1ebb8da864ac6d0"
    sha256 arm64_ventura:  "d241829b00774e8a623956b2d924eeaeba43aad1109eb97d8130bfedfa6e084d"
    sha256 arm64_monterey: "e3669040059256e4303a2675385fe220ad2c668d952ab861ef2c76ed5b891f93"
    sha256 sonoma:         "562ace56e8f2224cfe823b9e6034f677ab917985e86e29f30e609d4f025a9e1e"
    sha256 ventura:        "6e40bc30b6973c062101cfa6aea43d95ac9bb0cc29e866385868c112f5c87e7e"
    sha256 monterey:       "8d78f598ff4c6a1ea00fc49bf2d04d3f7329458b6621959620da5c163e057d51"
    sha256 x86_64_linux:   "c1217184270d2543f486b8464feb0ddc6f8883163ad3cf41a440290edbfdc19a"
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
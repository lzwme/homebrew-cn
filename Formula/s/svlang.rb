class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://ghfast.top/https://github.com/MikePopoloski/slang/archive/refs/tags/v12.0.tar.gz"
  sha256 "64b3eb9d38ee126e009cbb8da0cfa6f68d970334e52ba084ad7c68e4b5fa804c"
  license "MIT"
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "332e75aa965dfd3c10aefd9623b25983faba4f9d07dcc3b294ac8e3f92d9d81e"
    sha256 cellar: :any, arm64_tahoe:       "cd2120ec05548a5642a7cb7972b89181b37a48a6f8ece48405f34e693a3aa63c"
    sha256 cellar: :any, arm64_sequoia:     "fccb04c7241e24312619b985b322a710c08881d9a3663fa4428ce1ccb4d06b16"
    sha256 cellar: :any, arm64_linux:       "3e274000c539616552fca6a6d5230b832e89d76a1049fff792450fe206e02b0c"
    sha256 cellar: :any, x86_64_linux:      "ee0e1b158befdb1d10169935b75887839756814f4f9cc0edf28b0dcb6b02c713"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "mimalloc"
  depends_on "tomlplusplus"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  # Needs std::views::join, missing from the macOS 14 SDK's libc++
  fails_with :clang do
    build 1600
    cause "needs std::views::join, missing from the macOS 14 SDK's libc++"
  end

  deny_network_access!

  def install
    args = %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DSLANG_INCLUDE_TESTS=OFF
      -DSLANG_INCLUDE_TOOLS=ON
      -DSLANG_USE_SYSTEM_BOOST=ON
      -DSLANG_USE_SYSTEM_FMT=ON
      -DSLANG_USE_SYSTEM_TOMLPLUSPLUS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.sv").write <<~SV
      module top;
        initial begin
          $display("Hello, Slang!");
        end
      endmodule
    SV
    system bin/"slang", "test.sv"
  end
end
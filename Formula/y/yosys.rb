class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.69/yosys.tar.gz"
  sha256 "6dad6412cae417f5a53e2c943c2aee160162cfc1bdd31669230da1b7e3522571"
  license "ISC"
  revision 1
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "721d4ca90b7a6e54444b0e966f0d8e2946c824521065d97c46badd02864857ae"
    sha256 cellar: :any, arm64_tahoe:       "80d534c82b29426761d7308665713423f278c65442c0d826f13936c6b94ab885"
    sha256 cellar: :any, arm64_sequoia:     "ebcf5c499ce0451b78916cecc0f7770c43078da2b51bbac793e0cbf47cb2eeca"
    sha256 cellar: :any, arm64_linux:       "912f49b90da114f147df3d71e318269f8224dfb3d46126af9bdbe04cc209e861"
    sha256 cellar: :any, x86_64_linux:      "af0c3a822e3fafca65fe16ccba425bfb813a458be15c11ac46211132b4792175"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "fmt" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "tomlplusplus"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Avoid shim reference
    inreplace ["cmake/YosysVersion.cmake", "cmake/YosysConfigScript.cmake"],
              "${CMAKE_CXX_COMPILER}", ENV.cxx

    args = %w[
      -DYOSYS_WITHOUT_EDITLINE=ON
      -DYOSYS_WITHOUT_SLANG=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
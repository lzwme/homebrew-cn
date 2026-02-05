class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.62/yosys.tar.gz"
  sha256 "731c5c6f717b988153d0149f4c98059bd96e3bbca9704f52646ab7da97ea42aa"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "68bb2e98560e4758e7e68aec0d4489117cb57b289d7f828efdbaa6b7cd40c1d2"
    sha256 arm64_sequoia: "1c23f823d7d6b7d3d89e8d44708a755b7413b6b291f95586c86ef34d88f4052c"
    sha256 arm64_sonoma:  "368260bb3909510558fcd18e31329d25b203b6308271f4c6cf47a86e23ebef86"
    sha256 sonoma:        "3646547dd398121291841753eb5538fc3ade3fc87e1a693c8f37fb3aa00e19c6"
    sha256 arm64_linux:   "8d5f7e013216904b8eba5527cf097cb1e46fe524d4069611100490bc04a3e494"
    sha256 x86_64_linux:  "5c6e0ff389d38e9bae6aecc82738c9686dffb529afe5933b8140a88f66bf3e32"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
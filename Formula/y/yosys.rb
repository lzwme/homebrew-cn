class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.54/yosys.tar.gz"
  sha256 "99e2a5661e998a23c7c100af4bb63aebb96f13d5d68086ae6a5f1ce920e9783c"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "627cd3b46c93fcb2525e44250c9a23c20e3183f7ba25b7e17c8bedef3d982baf"
    sha256 arm64_sonoma:  "e691935e8cd4e2d2731ff2286b0d5d72082c193cef4d25073f69fdf2f064ce6f"
    sha256 arm64_ventura: "c8666f10a8839f1dc1022f6668a29681c1849f3c3d366182858f980d97ed9c5c"
    sha256 sonoma:        "204622cc83b69cfd6d833c479ab98639808cb319eddc8380ac633943199c9121"
    sha256 ventura:       "3bc02492ebbf89e33c4765ec8706bbeec353cd9e07b088f8fd747629972ecb9c"
    sha256 arm64_linux:   "f4f30e419f173bca31ef1d3511c05e5d0e7c28b0ef04a2b4b451c4067cb00b1d"
    sha256 x86_64_linux:  "11b9db7cf32186cea4f004f70ff65e36c88ec47cf8259072cfc14ea04961e4c9"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtommath"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
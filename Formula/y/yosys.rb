class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  url "https:github.comYosysHQyosysreleasesdownload0.47yosys.tar.gz"
  sha256 "76038d3de2768567007e7c31995b17c888c16da1cf571d8a24b4c524d3eddfdf"
  license "ISC"
  revision 1
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "c4fd9b8235e9731f3668ea61211ad842e664afb18ed75dc6bac2590fa98d4c17"
    sha256 arm64_sonoma:  "38859f08c0a027e47339c1729f30f396d47633e65652e754f5fc2a8a81d9b517"
    sha256 arm64_ventura: "c4dd24e07cc8d45a89a0930543b4e94a50c2fa1b4e3d21b91618c45ff17c1ee2"
    sha256 sonoma:        "72ceca73083b1a82983708cf230905be6a4c8609b4782e86639536231cbf226d"
    sha256 ventura:       "8177facddc5ee351c418dfb2de1d198a24f61d75a5370d6ed166d002ec2ea696"
    sha256 x86_64_linux:  "a2a220095e32260c05187ad03ca40b3c67e67ee0a470b3fba5b2896aac9200fb"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare"adff2dff.v"
  end
end
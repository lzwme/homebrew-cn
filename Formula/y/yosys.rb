class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  url "https:github.comYosysHQyosysreleasesdownloadv0.50yosys.tar.gz"
  sha256 "ec70b602d0046ed0a7b4fbcb86ff5813fc0b4362ebdfed9cab21d98938d2790b"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "fc8b655998c8653758407020999370201909091ab5259e3b0bfaeac56b1b1f87"
    sha256 arm64_sonoma:  "8b6ddb1d03f04cb151b54cb4a9379ba2397f983163e7cea4871f184fa4db02d7"
    sha256 arm64_ventura: "270328d0f9d7ecbdbc3df14de0950deffa74cfda3367b4056dafbb8913f65fdc"
    sha256 sonoma:        "13f7c46258e0b0db256657b8b01888bc719fac2c94b93c4bcd5317c4db1dd652"
    sha256 ventura:       "01b51073381342fee53cbe243befdff1a0662a4ff6c6c961b93ece00df092b47"
    sha256 x86_64_linux:  "c35e185c3d81007843cd5a467c762afd06517f88d5e16019f013e77b983b61da"
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
    system bin"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare"adff2dff.v"
  end
end
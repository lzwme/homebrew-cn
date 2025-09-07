class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghfast.top/https://github.com/YosysHQ/yosys/releases/download/v0.56/yosys.tar.gz"
  sha256 "b5270419812a38ab3dade6003130fc2eebc9757a4ed9e48b0ceb311428743d04"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0fbba5b942612395e4515a3cc8fc66532f954c6873538362094d3c249b1d1353"
    sha256 arm64_sonoma:  "96c88c062cddb7dcf27305120030f0eba4c4163d02ed939c68e0764f5cc95fca"
    sha256 arm64_ventura: "0f39a258ef3bbab82f71f2dd1f699e71c4fcfaf1a4df4ffc352ac69e52a5deea"
    sha256 sonoma:        "57660b57cfbf67d94c1f775470f1e6a8ed4d13e143ca7615454a28c2bb2241c4"
    sha256 ventura:       "8b257260ddc652a20272b4885e79875b4f674811df993085e8023ec960be3b4f"
    sha256 arm64_linux:   "7c782b74b00f9ae2a354244609a478fcf0f3dc2059617975ba225524ba3fa89f"
    sha256 x86_64_linux:  "95e0144c88ee718da54c6de5f79f91f9566945352967ef75eb9bc60b879512dc"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
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
class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://ghproxy.com/https://github.com/YosysHQ/yosys/archive/yosys-0.31.tar.gz"
  sha256 "aadbd885b72a6c705035abcf7e2eb58d25689b18824ad91c71efd1d966f0bf50"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "17ede77828d74cbebefe9da4385528bbd93a8b15d6a3fe04380a5625110bd28b"
    sha256 arm64_monterey: "a0aadbe12bcd6ad75f02b66e40189c229d4c8ea1e5a370c9c2eb74c3c2641ea5"
    sha256 arm64_big_sur:  "31e2bd4285234f1088340d1ab8f4001dcb8d3652e53559c1ef512b58704fa279"
    sha256 ventura:        "707f5b0594470206b7d792297c6633021a6c04ff1492a1cb6572f5d583eec3cf"
    sha256 monterey:       "50433c67e41ce240c64d25b0434e4bed6ef3fb8c05200e3efbcf1d84a9f7265b"
    sha256 big_sur:        "0091b08911765b85492fc1f2ba82bbcb67a6a76c8d01942db3b0da3acf463793"
    sha256 x86_64_linux:   "28898524b7569e2ce83dd79a0e59cbd9487671bc3da2c1727002f4858791face"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
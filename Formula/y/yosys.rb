class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  # pull from git tag to get submodules
  url "https:github.comYosysHQyosys.git",
      tag:      "yosys-0.45",
      revision: "3e0dc2ff1ee0dfec10e96b7eaaa774231ba4a248"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "1d4318a4d819fca8fc93af86d19cf9d9ed8782c4867c16ce51b577f677ff195e"
    sha256 arm64_ventura:  "c4123b638f8a9273a90917e51d20f8edea6a9e64cf038b05d28225d186b9a224"
    sha256 arm64_monterey: "7839f5634a993c4c6e2c8f37551d80fd2142ab78db6d3feb233adcfbccb0fbc7"
    sha256 sonoma:         "372833bf11f3d95033ac373abbd9440f2766cd9b68fee841b11a14f1d47dad98"
    sha256 ventura:        "848e66c0f4adeeed78f0edb62557e3f856bc4fe0bb5580c28a91b529e481bb81"
    sha256 monterey:       "f6bff3439866afff57bcbe53470ed86c04a1cf02598d2851bc192ba0b0e25d9e"
    sha256 x86_64_linux:   "6971a541213213afff96cddce5893944076f12dd35270ec9be64f817eeea31c5"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare"adff2dff.v"
  end
end
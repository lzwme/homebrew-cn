class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  url "https:github.comYosysHQyosysarchiverefstagsyosys-0.36.tar.gz"
  sha256 "d69beedcb76db80681c2a0f445046311f3ba16716d5d0c3c5034dabcb6bd9b23"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3d46186a5967ac794489758e2c553d5b35c8ec664bd6c8bedac30ee85f64e483"
    sha256 arm64_ventura:  "cc11db12be552c09c99c3f16342e49062fac9fef5286f049e381d2bde728c72f"
    sha256 arm64_monterey: "020c360a1b3848b48815618b5fb2eb5658c26cd32ffc2e39f848e27b5564ccb4"
    sha256 sonoma:         "3509d6182819b977c154c90dd6a1b5b8986a3b798e55855fe226f3066e5a091f"
    sha256 ventura:        "1995d15e729662853d1a218d06855bdf8735e646c1131036cb09d1fc10342116"
    sha256 monterey:       "6328bea326757bf26c377615afe828ef19615d2091edadaff6333620552b31b8"
    sha256 x86_64_linux:   "4d7bc306ec6d14ba4cce19209146884216ac8cf3983fbdeaed41cb812997c8a3"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare"adff2dff.v"
  end
end
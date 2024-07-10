class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  # pull from git tag to get submodules
  url "https:github.comYosysHQyosys.git",
      tag:      "yosys-0.43",
      revision: "ead4718e567aed2e552dcfe46294b132aa04c158"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "b2bf467d0d060e5d88adaef11a32738eca2e1015553bc025b253f8118720c359"
    sha256 arm64_ventura:  "f340fcd9be9706f7ff51221e0e70feb9fb3aa7215c026886bd2a41eca78fbf83"
    sha256 arm64_monterey: "ac17398cedbcadbbd4b3d4875479fa14cd1d283ce2dfe0766462081cae230e31"
    sha256 sonoma:         "60c1b3a667b61daaf4e0902449e2424aa79320dc751f6b2ecad156ff39a04a52"
    sha256 ventura:        "0a13aac357610ca6bc38277a18af751f69a7418ba6ab00becb39b5b86bf7b6e5"
    sha256 monterey:       "297fc12bdc11255a0267968299c72e68f3be266b3639db7b3bfed79c39cf9a34"
    sha256 x86_64_linux:   "86eddf6fa626935b50db4a061f4fbe263c1be559766e3f1e11556e39b45a4490"
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
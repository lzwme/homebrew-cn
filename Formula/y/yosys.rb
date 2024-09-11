class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  # pull from git tag to get submodules
  url "https:github.comYosysHQyosys.git",
      tag:      "0.45",
      revision: "9ed031ddd588442f22be13ce608547a5809b62f0"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "87c3a361b6f149bb5f2854fd4860ace367ca54d4422d460ce94a4f6c479a11ad"
    sha256 arm64_sonoma:   "c665c6c1759f5e925630889d8dec9f871da399e8e78126a4d33e66e79c584c81"
    sha256 arm64_ventura:  "56931ee530d10c88453368c5f0e69a8e6014f6c4d172fa27af9ce58c107bc14a"
    sha256 arm64_monterey: "86dc824de0c8b09a7ecb970151bf4d592f8e06a61e3f70c54d3230b586d7b1c9"
    sha256 sonoma:         "dfd01ed575a1251a9548addb0f934f926da70b756cd79b65a53da85961d74907"
    sha256 ventura:        "677ee8d2b46cb2a3c24045f4b6b6f28f030950d28aed6f5a0994eb8b0be15c05"
    sha256 monterey:       "8becb963cc9b8046909d6390285d27d9679f4bfff6716e214680c28b99c528d2"
    sha256 x86_64_linux:   "c98e630df957542e005891e168201795cfc7cbfbde49a76552d1ec1a2a7d49b2"
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
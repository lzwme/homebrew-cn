class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  url "https:github.comYosysHQyosysreleasesdownloadv0.51yosys.tar.gz"
  sha256 "72abcf81925fc7232cba25d190a48d7be5079569ec2ba233bac2bb116c383eea"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "a354577476d77f942ab9f61cd95a2530ccfcfc4a79e277d12d2e80bf1f46c904"
    sha256 arm64_sonoma:  "e3c76e0f464606f7baaf492a89ee5dab8566786404affef38d367d9882ac7b32"
    sha256 arm64_ventura: "c0b66fbff4268e9be8e7f1fb8ed53d2413d025d91f96ffda2c5622856a38936e"
    sha256 sonoma:        "8b37695d129b043960da3a3b2be109d0bc618ce6af8b4dbb9c14cc6abb9c99f2"
    sha256 ventura:       "2f9d747849c43bad6daa810a808ea113bfd4b1c811f0c591dc9e64fc017ff3ce"
    sha256 x86_64_linux:  "e1b56a4e18415449613efdc904794ad9dac68da20352bb9cc3f809cbf2ecc790"
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
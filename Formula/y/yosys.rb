class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https:yosyshq.netyosys"
  url "https:github.comYosysHQyosysarchiverefstagsyosys-0.37.tar.gz"
  sha256 "98e91253b116728e5db037512a4d837529d408269358f06fe7b4633c89cf8756"
  license "ISC"
  head "https:github.comYosysHQyosys.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "75e162b6bdd1b40c1dd3c0b1c21662bea79bf4adb4716ff4aa721aa0960fdbee"
    sha256 arm64_ventura:  "7de8026e4c372e821c4928958756d1e7a3e20849809c4a08520459b2b3be06e9"
    sha256 arm64_monterey: "799a19346e10752dedb580545f0604eeb364251addec40b517d3f0944cba21eb"
    sha256 sonoma:         "d1e72f27603e878dd176fd9ce6192dcf2d57af9d40a6483450fdc708ad690c13"
    sha256 ventura:        "cd130789df559a9f6c5da49e50554982830c76216ea8a1b6cf99f839296cbabe"
    sha256 monterey:       "35456dad2eb30c7815e31643b81c12c4485c2c1b0265c68f799cf6fb2bb86860"
    sha256 x86_64_linux:   "31a406221b298bcba80883edc9b97b7dc33e510da8153079c404f50c073287bf"
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
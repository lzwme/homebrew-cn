class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https:www.ime.unicamp.br~martinezpackmol"
  url "https:github.comm3gpackmolarchiverefstagsv20.15.0.tar.gz"
  sha256 "08935f99445689474265d98cf14b403e303a3530eb0e849629259871572d9b15"
  license "MIT"
  head "https:github.comm3gpackmol.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc4a8849256ae25898a6927c8458c05388914b1169cdd76124d96eb6f6ef5ee0"
    sha256 cellar: :any,                 arm64_ventura:  "344c5e6d15268d57a29403ff6d33418a6552a1418a76644e621331771d55409d"
    sha256 cellar: :any,                 arm64_monterey: "5ca5cac888a34365f4ff9785d8622bd8f331a6f1bc44e8b6630c21eb4b1c06f6"
    sha256                               sonoma:         "0dd7b05d52967ace624ae3ff16a9d2c9c02718e1ef7275bfaf03add4f07dc686"
    sha256                               ventura:        "7c46a0028ab2a885c5e57a72847c5b7373f4d364319c8ffe665e7ad2147233e8"
    sha256                               monterey:       "d42cdeb0d48c816f747f0b05c0356099824700243bb72991eaa1447c6789f6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe1e7410a5edac436d19b7c38f6f02acd89b2ebe1ec5dd09ecc9eec64891965"
  end

  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https:www.ime.unicamp.br~martinezpackmolexamplesexamples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # Avoid passing -march=native to gfortran
    inreplace "Makefile", "-march=native", ENV["HOMEBREW_OPTFLAGS"] if build.bottle?

    system ".configure"
    system "make"
    bin.install "packmol"
    pkgshare.install "solvate.tcl"
    (pkgshare"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}examples*"], testpath
    system bin"packmol < interface.inp"
  end
end
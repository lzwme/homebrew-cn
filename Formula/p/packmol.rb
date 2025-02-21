class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https:www.ime.unicamp.br~martinezpackmol"
  url "https:github.comm3gpackmolarchiverefstagsv20.16.0.tar.gz"
  sha256 "c6e28a31adba17273eaafca7134b126dbcbbc6927b24a52e886a2a0794cda24b"
  license "MIT"
  head "https:github.comm3gpackmol.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9092146f495c98489c749d32bbb02aef6157c31bb45a8a3cfd1b80350c11b3b"
    sha256 cellar: :any,                 arm64_sonoma:  "1a8ccc2c91b4a6897b1189c6265adb7131be3bf78b57e1707e69cbbd20b929f2"
    sha256 cellar: :any,                 arm64_ventura: "15b47f6996ecc36f93bb16467a57f5c6f3a336e1260a0e2d4862a62c15cefb72"
    sha256                               sonoma:        "2385a7df9292607e7a346b26576cf03f742b3e63914ce0d64504462fecb89308"
    sha256                               ventura:       "ff8fe40ab5cc1980358d3c231d8fc07a292b088216869821700afdaf862406f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b1a58b91a2b8ff35d095a816a01324cfa47281423098dd29becd3d4ffb8682"
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
class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https:www.ime.unicamp.br~martinezpackmol"
  url "https:github.comm3gpackmolarchiverefstagsv20.15.2.tar.gz"
  sha256 "7afb96f4d6ab7704055a03b0c8c73eb713ae7b064881b8c5aa9866c191b0cc18"
  license "MIT"
  head "https:github.comm3gpackmol.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9751a1f16964288f0e87eb9ae30497239f1b391a1cf8a0abea5a2bdc6048d7bd"
    sha256 cellar: :any,                 arm64_sonoma:  "465b254145fc857e25c6460a0ee26a51496ea3baaee24951dac5b8eb32371888"
    sha256 cellar: :any,                 arm64_ventura: "391ed8cf9e5791b674bd329bb6147d1dae81a2f084a111fcbc2ce79be1d34bc8"
    sha256                               sonoma:        "01809ef9b7a29945d4f83b4622cf982760fc06d5b65f152db3469f3adb0c53b1"
    sha256                               ventura:       "be9b4078941dbd8c76dd11945cf6b575c88f414767ad5973e7d257013ec07766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0657b8b6a8fe58c5105bd78b56029a3454f32d5e5861e68bd3cbafe09f3cd05"
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
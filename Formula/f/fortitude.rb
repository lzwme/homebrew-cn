class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "f7ae366a2befaaac22d9189a422dee494cd006a1c192c40d484a56dc806ff1fc"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5140201e083cdf88e748cc1f8d96add21c8b0b6bf59e8dd41b879255908201b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcba684354bb636d970a12a255ba2cfe05eb20990c9b3b5c03cda42ddcf15785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880fde075d0f3c3be223c64041c296adcebe5f1133c1c60596af6f8ebcd243c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5afc605dc866c7c80e62b7b801389a9008bc6331c336d82f0c9e86659b14ad7c"
    sha256 cellar: :any,                 arm64_linux:   "460269e447b9d225ec63972758d70b11efe1eb8ca9ffcc0eebbe1c418fda6076"
    sha256 cellar: :any,                 x86_64_linux:  "d9d86c2a12cd14c3d304a4b9daaf3a47bf872d277792b013e0239e7ce3683460"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortitude --version")

    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 --output-format concise 2>&1", 1)
    assert_match "fortitude: 1 files scanned.\nNumber of errors: 5", output
  end
end
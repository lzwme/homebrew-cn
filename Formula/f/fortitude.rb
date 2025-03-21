class Fortitude < Formula
  desc "Fortran linter"
  homepage "https:fortitude.readthedocs.ioenstable"
  url "https:github.comPlasmaFAIRfortitudearchiverefstagsv0.7.1.tar.gz"
  sha256 "c8f938e7a4704ddc17e9642114556e84ee544650089b2192b11408b82e299e76"
  license "MIT"
  head "https:github.comPlasmaFAIRfortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc62862328a3e9310e982f276d64acd9a813aff880810c39430cbd0c3cda5e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4893360f255bd4194651fd964d0b2ccb4a23d81d775ea9ad0f49aa4fe43695c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24bc82897fcc7502ab8bb94110e432aa0679ad93a7d1ce9aff65943623d18f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f993e19cad482db59d623acbcb03d116fd349c73a31fe79c7be1a44307756e"
    sha256 cellar: :any_skip_relocation, ventura:       "d61d81286e39d17e08e7bc883278d5088249525d4f83c1d4058bcf85b50bd892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d5221875fb2a39c49ecda33c5aeefea6cd543ea7ff40bd38d606c31dc24e5c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fortitude --version")

    (testpath"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}fortitude check #{testpath}test.f90 2>&1", 1)
    assert_match <<~EOS, output
      fortitude: 1 files scanned.
      Number of errors: 2
    EOS
  end
end
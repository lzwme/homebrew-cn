class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "7f13f5f70ee5620a07019fb70dd2122892a085ac52f4237a64edbf30b9faf042"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6979ff4912537c024574a7533cc10c3ff6879ac8dd11fd63967d7b4e5d5ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ed404c89024423d03e38db8a346ceef81fc95c9d1e569aef64e3f4b045ac43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c1311c6154e322fd2c003850f73fc637a7567605c3a9d6eb04b698d328981c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "db784829e33aeea78ddd7f0ca40e6ac8cbb7563d71bf21c4760b968e9323079c"
    sha256 cellar: :any_skip_relocation, ventura:       "8c54f210aeeef45b557d8b8f39809737bc73664ddebd0b7d124ddfdf4789b157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6725b9ec6f3dabec44bca4e17b6f4cb0e2b4d9baf8934b55614e45a590d26904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4333218ec6c5be2be3db0360c49e3123f09dbf7b2473cfc6f0f71afb32474a8"
  end

  depends_on "rust" => :build

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

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 2>&1", 1)
    assert_match <<~EOS, output
      fortitude: 1 files scanned.
      Number of errors: 2
    EOS
  end
end
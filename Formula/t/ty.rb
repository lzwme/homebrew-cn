class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/19/16/d01c968d405acae51c07872e80f30f3a586235bdf52c9847ca0917a230a3/ty-0.0.57.tar.gz"
  sha256 "bc058f564868690283a0420d09c269ec8be21e8e43b4b49ee975a17623092e44"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080852545a189c31d7de2042fc5462c21f4c1edb47feef5f179ed371557555d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8871c9bdecb141a71e7e92a1d8b1c7c5d6bbf97f710bf9ab2a938918057f2083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efcef59f596ccda507c98f1e781caab776b30f7d3168614c50123dfdcf04a354"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c911ad81dc465ec74554cf9d4ec88184d6f29585553c9b6fc50ee95e1f92971"
    sha256 cellar: :any,                 arm64_linux:   "e22c13d71175e2fefb87b580bebd4a14a2e08f5bfdc3ec0e3e8128a4cc7d687b"
    sha256 cellar: :any,                 x86_64_linux:  "960d4da5446d4c3944c71eab2cf12c6c3a5ff3affca8257ae2d54bd97c68c533"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
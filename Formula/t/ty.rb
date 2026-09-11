class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/54/b0/6d1b10e0d422736a3c439e487c950ae785f401d71ff879d5be68bccb6d90/ty-0.0.80.tar.gz"
  sha256 "fe86bc91327e45ff5e3593b7e306e7f57a44bc0608f38d647b8d97bd99c96013"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "caf1a22a80858b000f89dfc4048ae828be66244027b78f4cf02ccc5fd65e73fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e67ec830a954af10e8aa922d04c505ae02bebaff92507cfa5bb1df3e9c4df298"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d89d9e5860d8d26f5b87a2d84235e0c2bd460470b528886e0d1f701780ac2475"
    sha256 cellar: :any,                 arm64_linux:       "4a2a97cb62c5c9b8fe4ab865aad7f0b2de3dcf7b763c03bf1471ab9de06aa2d3"
    sha256 cellar: :any,                 x86_64_linux:      "c8338008ff23c402d02b862e25e0aadb45a231bdcac7ecca1be6a2529ffe2078"
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
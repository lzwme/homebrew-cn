class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/92/63/6944925d0fe9a4bb9cc744e6c045a42bbd2ee4654c103190674577a36c3f/ty-0.0.61.tar.gz"
  sha256 "acbf0d914cc7e2e57ccc440036af36114819e2a604a5ffb554e72e4ca7dd65a2"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f51c7488ebad10c8e549264f6b5d3165652a539c70750bdd487dd0574c770ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e645dc45b535add6bba44d86119007ca794123565a0bde98b0e576e7353b066e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d547a6974b434aacb4a1d80e1d2e6f525b8bbb5caea9117108b68b9a16a3a6b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7efdc2c41283ae5c37fb6da7747ffbe35d905480fc4e8e9ecf9fd81fe888806a"
    sha256 cellar: :any,                 arm64_linux:   "416e53e13660e05a44b4dfcfd78891f1f7fb7fcc96d043f26433a534768c0247"
    sha256 cellar: :any,                 x86_64_linux:  "fb636d0ee136244f90793901b2311334fc5e58139872283b7a4bee6967687dc9"
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
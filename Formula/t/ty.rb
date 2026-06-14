class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/1d/8d/37cb91808069509d43a2a11743e12f1e854fd808dbef2203309d256718cd/ty-0.0.49.tar.gz"
  sha256 "0a027bd0c9c75d035641a365d087ad883446057f9be0b9826251c2aecafbf145"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac206e45cb742e018b6ebed4b16e1c5feef7b6f6c716326fec2dda14c5de9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f10356179a7ac3a789355501447eb8a1a90ea3cd9d288e8b9171df41080ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1f3c805d764789a5a14270f55ae672cff8b119e41021a78ee09652cb5c31751"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff6db348537fc981e51cec86d7f48a0fcd942190d40ff99c3a29a76a28e4c97"
    sha256 cellar: :any,                 arm64_linux:   "f692bc69f93d6f697303febf6764d87fbec2621919e4b65283dc7f796b08416d"
    sha256 cellar: :any,                 x86_64_linux:  "9eba8627b354504bbdf2cbaee33296f7dbff8bec975fbe100231abea1877b17d"
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
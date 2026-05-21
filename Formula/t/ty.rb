class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/33/3b/45be6b37d5060d6917bf7f1f234c00d360fc5f8b7486f8a96af640e25661/ty-0.0.38.tar.gz"
  sha256 "fbc8d47f7630457669ab41e333dc093897fdb7ead1ffc94dcf8f30b5d39aa56d"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4af47c15a026c35b6d87cae902bd8120f644ffc152047f8c0c2c8a74dab0ce9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389ba63749f3f40028de4474241ea1739d50633c00deda4d348eacee9d1ea554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6955fa841d6f08e39fdd067a69a02094c99e1d65ced261fad78fa05b08413eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ef56683051e907e58089f5bd93c2138c1a557f99e2e3baa8bf962b73cd223b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cacf36eab5dacd81d27975fbebb40fae2d3bb261ed68b0a5f4b348a714da48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b4adcf8d07f3b8e0d279d3b43b3855f1f383073b2d5782115d47ea8665dbde"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
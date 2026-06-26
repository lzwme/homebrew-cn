class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/96/87/d5a1d099a41ed22f939b9eec5af3c40bd907409e673cc0b8fcfd1e354ab2/ty-0.0.53.tar.gz"
  sha256 "86e8c522b1a1ae267cd6442cc93c0c954a2a59b89565e4fb493c1133bd5a056e"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f453f6a792363f035e657c6fe98ca1d95c22d208ecbfdaf5e757b62120059655"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e62ee821df60603e47d717b68cb57c81b335c68562cd0274fa4a2a0002eb82e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a05e58606bb703dc4e8b4b99fded1908913dfb9f911c2aa1b4ac21596fca32a"
    sha256 cellar: :any_skip_relocation, sonoma:        "88d5e3bcc71c23a45ee440f668ab572a08da24530860125064d23b4230edbcef"
    sha256 cellar: :any,                 arm64_linux:   "9e53df20c1bc1b137ad82b252622b20d669c1591a6a3f61536fb3a2f9bdd503f"
    sha256 cellar: :any,                 x86_64_linux:  "defb2aa3e0cfd4ec7ddca05b69bc41a2e74703227b3bbb691aa6ea92189bbc01"
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
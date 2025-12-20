class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/48/d9/97d5808e851f790e58f8a54efb5c7b9f404640baf9e295f424846040b316/ty-0.0.4.tar.gz"
  sha256 "2ea47a0089d74730658ec4e988c8ef476a1e9bd92df3e56709c4003c2895ff3b"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b813a20aaeaca2436a799888b7cad6ae83c4f376c21f4089fb5cb9f82b6c11f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88082311a1b26185477d333e2afe37661204cba99585fd5f6ff1c7a57ce9d2bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8106beed7ae87d5a56f3725c99a36f7d87c579823481a8c755d8faed2b576ee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af07ca853839cfd012ed37d0c8b0c075415aab57544a32b066fae35b289ad36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd5a6cbacbf158d23a5d7b7ffb87c5b2591f8a1c9c31456aa1ece072d668d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2d8c6670f639c4531d2cbd0e5d040fcd83b941e07d1caa4c37a84dfcaf1698"
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
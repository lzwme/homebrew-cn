class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/0c/ad/7a6568b4a8dbb6531ef4f13cd5658e0e4fbd18b890a137b96e1ac87638d5/ty-0.0.48.tar.gz"
  sha256 "aa54d69b755ea3f765975abdc5fe41f8daca45b1aabc57f91ddd3bd4b7e0c2de"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "512365adf5cb42781be9a42bfe4f1fa0787a6490bc6fe4c8fd8907c61a860101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897ac0826fb5e8a0c294033ab1da04337b06eb468a16e99315af58b9828b20cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396ac832c954abb76df18d49572893eceb2d53774f2e8ed76a96d4deb0573174"
    sha256 cellar: :any_skip_relocation, sonoma:        "b874d46a5fef8e7ae87bf3d0968ad0dd31afa4a72151eb12f9db6b57e3ae7133"
    sha256 cellar: :any,                 arm64_linux:   "ee39525f1eb95901d4ff226060c5ddb8b76ead8db29d72e4c1bf264be8463570"
    sha256 cellar: :any,                 x86_64_linux:  "e67bda6fd927a2cafe80e9131e70907df319d4c5783d7fac9338433290788552"
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
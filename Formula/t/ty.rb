class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/7e/ce/352fcdba5c72ea20e5d2e46e28809cdb617575b71209d971eff2ace8e6c4/ty-0.0.51.tar.gz"
  sha256 "b90172d46365bb9d51a7011cbb5c60cc4f514f42c86635df6c092b717f85e1ac"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e580bf2d34364133f716b1dfe0462b035a5360fc0aa511855ccd6e56bf33be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ea153397eb32a7b828444e99e9d8aa6659ccabad3f12d265d5fa0d500e2908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e953c66c30cb5c43a6ad62bd9d3c397efa6800a17aae6f6a5392ca88f500ea51"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9775606ebe7c497707d814a3aa2bf1e9398e009fd49dae2a52ff2997d71eb3"
    sha256 cellar: :any,                 arm64_linux:   "68461aaf392b5eea6da4f69b74b6f6d50d6d7424f900d368996f033adedc8d02"
    sha256 cellar: :any,                 x86_64_linux:  "624d8e7d6bf6055a2292f4c1ce1b896446d7aec92e3be67621043df5fc3665fc"
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
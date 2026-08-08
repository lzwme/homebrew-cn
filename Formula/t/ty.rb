class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/8e/5b/7a618632dfe9373b7df572ecd7a08c8f799d772fbc317da82dd3aa363207/ty-0.0.69.tar.gz"
  sha256 "b65106e9ff24fa76e25e1142fb09c85244e815c40450e3021d2bf652c231bb43"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a36206d48669c54f2e296c9411402ae26736d8b7df024100b8dbeca0bdff76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde13eda1dd181e99fafea1a2f5820292963ab28d2a2c76a26ffd897ecd7dc8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b69b96c43ba2de74dabc452b06f6a82282e74b5c91ac97cf64c4ddfbf4b404"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eff3ad72d95268c9013d40f918d4eec14a442acc06d93816bebd4fac42a1808"
    sha256 cellar: :any,                 arm64_linux:   "248c78aed2a238cca4b5aa048f314f1f67a96f39ef9ab0abd5f98b7b9d60bf62"
    sha256 cellar: :any,                 x86_64_linux:  "4edf4a541db7e8f53bb49d2ec8650571e31884b32c2fa916b14f06f05d19e74a"
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
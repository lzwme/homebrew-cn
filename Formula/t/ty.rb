class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/74/15/9682700d8d60fdca7afa4febc83a2354b29cdcd56e66e19c92b521db3b39/ty-0.0.18.tar.gz"
  sha256 "04ab7c3db5dcbcdac6ce62e48940d3a0124f377c05499d3f3e004e264ae94b83"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74fc1911330e3859fbddcf17a84ffc155c6845500c9429d408fa9f64594d8345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd6088968b0ad6836b139cc6975b77e56d6294a6924d27f67f56be25a23f6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db493f10df84dca046a61b24ad67bb7305ef8179984ca5108e1722569aee991c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4f3428c01c8899e7e2b355cfd4c02ae35f954d27c19b57c15d0776b98874efd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb312e09ecc6fe86d612174b3bfc5ed00c9102a390ebe3977a6eb6a5453539e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec03881d7eef81b07c9268848e4f2bedde6b0756bf18c6473157b6a56a4063b6"
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
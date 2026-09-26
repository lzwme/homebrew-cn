class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/e1/f6/34f8869c45ea87fe6a931ffa824b1fe4428167173543d92988d631add355/ty-0.0.84.tar.gz"
  sha256 "0cefdb0cd5d399418dbe83c349ba605047b7dff815ae6f460c80e8522b40be67"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c774d86e1600890880ee836f62513a3bdbf1d3af62f47df9085738bd6cf09733"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "348022daa18a2b26114204d1dcff81e7e1a8c94b08216367f85f278061e12e68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc5482ccde62f8cd232c20f021e27d5b3bafd1fe0c0e0921110a3db1957e0290"
    sha256 cellar: :any,                 arm64_linux:       "b0c93a64ca3e463b7798a821b2dba9c32b90c996f588c26fe8fcbb9251abce30"
    sha256 cellar: :any,                 x86_64_linux:      "c7a7bef9feecd37aec87d91069482357ef1b6fd898eb8793582b56cf80476777"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

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
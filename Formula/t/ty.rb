class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/08/c0/9e26817a5c94d504aab30bffbbf53f836f4763dd0a947089246ff555eebe/ty-0.0.91.tar.gz"
  sha256 "b9c434cc1e3b106b6b9353b78ef304d5904c82cf440abcafef7134270a22b41a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4e6e5150f96656cf6fd02c5fd0f960b17169d602e23d3f7a367148b0da26b5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8d44445785c9c9e2cc748682a8ab241d5688a471db2689ab5180a68966f0c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "491252cfc23c64f2612887fc797214b29739f5430da47502938e21c55fbd5faf"
    sha256 cellar: :any,                 arm64_linux:       "0e042e2b982aba12f9d16ce33f26f312bceb45f9389fba740c63cf7e53f42b46"
    sha256 cellar: :any,                 x86_64_linux:      "be23f164f396a5db828d4b507ff436194df920d110c303b179346630fd87c8dc"
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
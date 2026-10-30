class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/8a/c7/1257c8c70e46274664db1eaf2b8aba99a1277470daaa39c65e7decd67c8f/ty-0.0.94.tar.gz"
  sha256 "933d2feca6057742d04af00c090621c139e7be2c059aa38b040a70532fd5104b"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42674737a6bdaef690f2823a7dfa773c928a7cbc022feeaf4a1258e424febbb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0ac3b0dd93f4975de0a1badf472573dab5e64272a53df035a4af6300e41e059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d69ebc89c378e2e081eb86724f88f7a164f51431aee09cf7a0414d69702e13d1"
    sha256 cellar: :any,                 arm64_linux:       "2c6dd06a297d7d4e957dc607a8d59c546a84019bbc25efe9365bda0bf2cc0ebc"
    sha256 cellar: :any,                 x86_64_linux:      "2dd0198e61849090ce08e0702ac24203c22dddb595a261d71f2a5171df6b665b"
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
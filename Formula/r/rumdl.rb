class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "533171eea1c789c54701bb57b20d31a75f317ecb74d1e980d1e385d51733072b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7fcffc653a5b78f58801f55cb4b1e9929e9acbe7d1a24f3197f664978401a74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbed81a0f3bd0bae85f18574d29d102503edeee13abdb9c3f6bd408faecb510f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f850a31fc98795ae84a60deb4de3158df953636e933e2a7d66c0082f02fc3a4a"
    sha256 cellar: :any,                 arm64_linux:       "c329ce12280aee5d1151f1ad316337c2e81f3ae92ab1e627d82b84b8b4c557f7"
    sha256 cellar: :any,                 x86_64_linux:      "a3c24397463efdc02f241474356ebb7b52569ebcd58c689f40926ac6223b64c4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
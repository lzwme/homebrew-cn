class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.64.tar.gz"
  sha256 "f4ef4b48fff8bdb09ba0de89f9735e2a5afc326bcacb0120592183550b733631"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df55104617c87297ad280a65389ccfb0b0bbb8b04a520e59b39d794e8cce6213"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeac08187a38bf4897c7e07d3c504ff8cba95d203b7c6b52ca377a29c2de1d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4879578f0d6eac37f04d4bd7b0f61a8fa852844b4312a0016e45b5c74a11d8"
    sha256 cellar: :any,                 arm64_linux:   "e215f70c6bc33a38f10c6dd108118d7e6dfa925fe295ee4cc29fb3efa23fb3d0"
    sha256 cellar: :any,                 x86_64_linux:  "c3599bd2a41cd0585b9f97fa8b5039b78c9f2355228e8a8ad073d712549e3077"
  end

  depends_on "rust" => :build

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
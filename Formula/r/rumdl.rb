class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "6c080f191528440e124d49628714e7dd196381476ca3c788bd8f688f3594aaf8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e340c1ddd1b248e8bc47b644795e07b3a2d2894256525c569844572725740ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "602c649cf91ff1952bfd3231706f977b27056e1f222a893ebe449dc45c93b153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306a83839226ab1574c6dff71c6188d20d3a684f54bceb9450a0ac9c4b7d7b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f24b5de399c933e0796eabd13b0032232b439c52df7defa96d0f9c6b56f0ff6"
    sha256 cellar: :any,                 arm64_linux:   "32460aab1209573ed7cfc7473224964772a94a27ff06724a09c2ddca4fa2d147"
    sha256 cellar: :any,                 x86_64_linux:  "7576e1c675be9abca70a8db7101eb6f01efabde6834ad44e4619fdcc1bb97380"
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
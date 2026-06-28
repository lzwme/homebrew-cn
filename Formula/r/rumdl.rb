class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "c4d676b27bd8049af471e5ed2f3983f72da990298c08a87388e6364080028181"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0f5757ffbcdad1d44e6e0748a465764f999d5d7ed71e7ded47551f4f376032e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0685e764760343e47248650bc7962753183e2e079958e311920c7218b66d1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0058bb9c23fe95724275e326f7f087045c1ec994f63590024c50984014843b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb0e0ef1717b0dcd0ff86b23df5cc6fa425930d15d5137564abfe693f0f965f"
    sha256 cellar: :any,                 arm64_linux:   "38dcb982fb36070881a0047ef9209d035253bbc27d3ea6a07317c64228d22576"
    sha256 cellar: :any,                 x86_64_linux:  "78db750dbd98b06a841e1ae260beb2ec324967d467c0720700ce68ab681bb77e"
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
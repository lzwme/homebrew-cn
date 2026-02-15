class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "cb57a732eaef7d41c17547d7604081dd8003356d9427edc82ecef956cb79c759"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40ef0d8b7fae01c4b59e7af8f427381977a13889eacfb7c8bf1ad11c93b407e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece643c54e4a593fa32958029fb8ceb41f2ae3bfc8588c662b78f9f58186c5b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ed3dc039aee554315981a4eee9c16bfe79a9c749102363cf765eb50a665ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "842ad3b30e212595073b982fa446a5549ecec924ac6a040beb0edb98f10f7495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "515b22347f59d912f3cfd1eea01f3be0c9e8dfecb44819fb77e53adbde0d443d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834f82f22167793c13532220ef3ad23d834eb74e95424694855df2c7f0f743cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "38c62f8be98fdd76daecd4e94a5afa694564994c0ea56877f2b62e0a4ed615a8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f42600475e8cc647e151dc39de8b7cd002eee33a5df1448a0fff24edc61661be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aef8931b4455b54ab686a585e1452f13f426adf63b282ae67f40d5a395dbb1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55e122f50d68936311e329c5115408874b9874238678188002e4383720d5879"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf38d51668a897a96fbf34e1063465b196b30de4a3ff5988d2a53d60b3a279d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ace40cd382c363c87fb6e975bdeae5698519d56f89d20ad221434c59c842fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1037db4ff623daf39aec707768cdc963ad2b7758faca73972c2633165f76be"
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
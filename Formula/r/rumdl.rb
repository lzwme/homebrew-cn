class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.62.tar.gz"
  sha256 "004108fcc94d9bdbd2c6b6da68f2eb8bd4eac0b0349d9a759b02f13caf5861c3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eee39900deff999bc916e57faf0e01d3d2b10dfcef0ccc12dc21e02f2ecf35ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c81e4ac19841988c3e9bb16b661c5784b19886df7a345d51f671a83aa5396aeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc69c5138403cd922e7e3f34bdee2436df8d7a3f48c23a323667ff234e1191b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e10ce5aecd8485dde14cab02fc7b540908718b26a72a0adf3793e0b24ce0651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dea7dc45b0d9262787e5137528aecd3d07c89537f3e99d623dc33f7aa5b77277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a05e3d0442b5fe492e0f7813d105190e3a1bda615d7ea2d25f9ed0a6f62ee59c"
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
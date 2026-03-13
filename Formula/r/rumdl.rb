class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "9bf0d3b7dd63b9766a7af9bec851f709451c64e5892711109d429609d93085c7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dccb90f95ab54c0c0cd742fabe46b64967b20a02c9c6048b123fd36fc579d98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a2285b89ceacbc6afac2601baf9e241149a4f2cde8e7957a9ce77f6d22473af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f26d3e248dfa9a4ff3b3a9775a162cd0e330ae1ffe246024fca62fc872afa5b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "48558a31a14aca557875ff80f2d4e402c760ce9dd1634cfb28313e8d15969f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b04b33e4429b83dd813c595e113f3bde9bad7d3e04e909d758a0c5f7964c576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46a4a9174b9e95400a68d353dcfc1513eddaeeb92247676bf84e7864b9b015f"
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
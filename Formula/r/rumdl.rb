class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "f9b079ab28ec73de8e5a27c3751394449b846b4b0cadec24438542d14a2851d7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88009c400971a3ddd69226f7e66cd83e5261eb752aae1f0af897ca65f8db2f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2c45dfcf98a42df4c6d10ada73f84a6f70a5986e2327134892c2d7696fbffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197a09202a78baadbff8b3c2b59243f3d4369a5122d3045146296f8f9ff70f33"
    sha256 cellar: :any_skip_relocation, sonoma:        "a911442d618a26aea131037e065bbc590ae3d0da06ea700f16abaabbca1bcf35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558eb5c4bcc8eb7eb75b187283f2ddd97414b519db1506fd9411e55c84a2ef12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853af3c6aeabae87162fe7414f65ff51391efa601d113b58f02a9325f0e07361"
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
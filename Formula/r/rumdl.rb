class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "eef98d9d9cae2532466b0018b861971d5055c3180b1dcee64911edc7585934b0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bb746a221680dea8efbae62fb6d069bcb53fd4e31e67f2d8d205b79d8cf0de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78aa57a88a71febb15845a8ea780548c39241c962c1f0305c4ee79ef6bd92e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18478c1cce4c7a84630feecda98f2f04c3b12accf4d4758674a776d256e9e7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "49703434a239eb1c18146282e93678d6419394f5e69ce302212cf148128a83a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba48de5643f2bc197d48129909a9b63117584ac561ec0317519fa0102afbadb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2aa805ee2fcb0a6d0a1adf38acad933949ad03a5adc6c24acc087f357786087"
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
class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.206.tar.gz"
  sha256 "c780cb07474effaf42c68f758daa2dd0fe122d1f671c3801e7971fe7ca0aab75"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "919e9eaf7c0d96c0a03ccff169aa0a3fcf0de5b660ddbab2221c49f9b9a59927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4336d28fe42386594696059fd0c139f032f8d0b3d69671ce581ac3a97282e084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b55f8c0a21713a70a5c3c034e6b6f0c545d6c238ee953eac592532f49063277"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3b02876522e585f876f406767ed8ee7de4b2a0d574889b534b717e9094133a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f8a267df462055919892db63e5b9f9f5ba8d48c8fae966ca9f55b1c4a5a9368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c95abd570326ca41cda5c4a03d97602c75c29413a270b7c8c0b0312546bab3a"
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
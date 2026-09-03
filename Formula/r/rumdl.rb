class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.63.tar.gz"
  sha256 "492079b102ebc0b8ca1dbea1b01893798380227fec0bbe8b88ed5e39938eba71"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55a6f059649b2f49e0ccf66f12bcb9de2fd9b1169c6276b5f302ff19b99c345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb55c9687f55d84a2ecedb700b95d8c6c551948fbbb5e00c68afecfd6c673e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bec05b88a21e11e8216dc89f31c1e40a13f95ba562c9a31d0c8045b9719c57e"
    sha256 cellar: :any,                 arm64_linux:   "c726acf6c006d45ddd313b0693bfd8466487503324ff2dab6d0191f2cee85ec4"
    sha256 cellar: :any,                 x86_64_linux:  "3f62c9cd32d73a3aa8a7a86195c3512706ccc279f1ab807d103d1661bddabdc1"
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
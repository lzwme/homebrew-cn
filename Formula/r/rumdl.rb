class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.212.tar.gz"
  sha256 "cb9b9ff14e86b068a4df72cbeaf996e696cda2db8463dff67bb4332c7bdc674e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7877c5370011b15b1a2a112fcf939c5e907dafbf53fa1733ae36ab667fb72cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34ce493c372ba75b4b92d493ec796e577b7b153293af60ad108a8ad67e9ecfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb48e697bbc0d411b5c9cbc8609da4ac19c18f8c119b098a91c057369c5f593"
    sha256 cellar: :any_skip_relocation, sonoma:        "44defdb119aa2edd233c3600fac0d61bf886b58f3731cc1ebb467978d6e34157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc97478d3a62dac42f162c922039104d2c5af954dab487bc476a463ea2fbcfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b2a565931ed3a0c7943469009b0fed15056d30420150aa8ac560af79482ca3"
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
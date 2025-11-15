class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.176.tar.gz"
  sha256 "3bfc48af21568315e22c2c5e524fc13b8c2c2d7ea139346b939c405c4aeaa73f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "231b4b38d7d83944545b5313a954bdb3f085379c57c57797b4e4b84070f83a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c77047d1ce7c659dd4d71a4ff730d736184129219948bb4a77e0e91d6b27607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b716846d447bb9f2de43b94779e2e57a09db8f16e1d706ba6fcc7273ffb5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ead4e35cfca80cfacf4bdec4af449fb097d153db6d914cd81b187837b2ff4e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21a9c986fe75ce559d7dc0567f4d972ad63ae2bfd2f55ff7c0d99b3d2f884ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d312eb4ba7d605110e577da911ad79f76e66905d6762e05ffc8e946d4117965"
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
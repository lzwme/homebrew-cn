class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "6c78551164c1715011df64deb1c5b6a6833d235734aa79ec15371da3992ef9f5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96164bcb4001231c7d72840c75c464310c3f9ecf4a62ae5807de98c32155b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f904e450e6ce580707f213e7993a421b7473f8d86b5f6d661a53f0d1626613fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "126d269e2d2d31264e5ddef7fc4ee3f6a31cf9927d17ff0527b01402b5b751db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2580cfdc8add8567a13e0e810c294d99b657cb5c41b2a2740611cd72794994c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61ba091c3dac205e683713399a2c7602e624ad07813512a807fa4932d290c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb5bf4cec84c70bf412e49e86fb809b5e64cb093755f9bd58edcdb93689b7d5"
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
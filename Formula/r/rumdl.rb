class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.199.tar.gz"
  sha256 "9f4a38c9fbcbe080b4a5e58eab4b10015d84247e519af7aa635f87efd0eaefb5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e15092b4590f085bf1aa57a0454660136e38a04274b7db13865cb568609d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6c60e06aa1cad21053bbb869c072e4163dc71f296c4f498fedce25b2354066b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7bb5c76d6ace6b4794908067bc0a20f936c3e4f46bb6f0fb0357a11e3c6fffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "41785ef2a067744ba795a0b4b2770c6cf7b4c5247acf3adf9e6cd411a354b046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774ecb844d5c3fc492a4cd2203dcd3a5cc5dc55fba5c463634b4fdeefd3d54c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd673e281726d334e9c361947c8ec90914c357da454377550383696c8dd98fb0"
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
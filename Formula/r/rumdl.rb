class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.204.tar.gz"
  sha256 "3199290b852b448b0bc39bb04d7e147b7bb29a793724c76412d2ad17471f2f6b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f31bdce00900408ff4d2884224796c6e96b25ea44be1d99d3e07217a999704b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c5e35512ecb4447bdfef775c9b6a60533a4400489bf4db7a8677f6cc92c747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0224ce936fe1114066cde5b99e04288b1439efc11b52c6facac002bf596f9598"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e896e36fefa09d961eb9347f1395ac8a02a2b7e08a7f78180eae48aec098bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e64d5e237e271b00215a4162b6a0fa19f719f6cff36e73b87bd0a8e991c34baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8488e8863ad7fe022b451d28d0847f3c9a2214e28703dedb20971b8c61aa3949"
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
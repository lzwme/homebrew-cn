class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.223.tar.gz"
  sha256 "f0f56ec17254c831d2024632b0716e8d7175d7a41db82aaef5d4cbad92a1b56b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b951fe301795688a5d9fd8793c66c5d9a11f37e6c9fcba833c9809790857044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e347021f2d583fd7d0edcff503fa26e833bfb87255e716b9b084dac3caa7f5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb4fc7ca8b4d68089c7a83894749c8d5e01f75f159d8a2ef5bfdfd2a2791e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f9a033412504836a20a82b7468a7044fa24f9a28c6af1f75dc0c006ac104c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e2c1c2c7c73bc0ae3c25b58f0df26833044205f034dad5847c99aa7178da32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849019a17fc49f9eb258a8f031fa4f417ce465cc94b121fdc57a5b4fef3ac9d6"
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
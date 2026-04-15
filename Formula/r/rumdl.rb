class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "a8043dcd10dea428897929e345110b7caa7ed6acb60590f00fb11092283f7c7b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "689c584e8bf763c87088b1b7f2e928eeed9de830ce15510aba32dfd436e6364d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c54bbe18c59c69d16e5b538a45c4c82af28e198f1ec487d1cea5514ff3b328e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f782929318f4fbaa2f572d6151f625edbc76734a6da500b01d9cdf2d4c3fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad41bf231f0a83ebc7cfe974aa6865ca9e405eec9b0491841c8294f062ceff91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb78f0d589ea6937500f6e3c7932f5eaf0eba2790fa814d2d2142b8fc2c614e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5029ea7d9403afbe4a179d1c38edff2706a1cfb4c61bb841c8b5e05312fcb88"
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
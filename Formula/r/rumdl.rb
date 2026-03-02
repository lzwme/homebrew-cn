class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "1ff8b41561cde4c16edb9b6cdf249b1b15ec9e243c667aebebc8b552afd627e0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69147319b2bbba39f26ef49f1fecdc45d317d22e0e5079a4d4b66f76493cb5c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52823bc27a286e1ece5b3f37b518aec7173a2925d7e5e67b2537dcb825e59aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac4cb5ba9d8b6950b8b7e2305ccbb10c66c16ac0f7df5de387da8f5345f36e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb23353d7157e73758a6ce177ec488c94826344e6023c93cc52c855eeb9066b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaec3150fbf7a142dc11b80d70429ff90c68e22661a522ef92b41d2480435808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b6331984088ad2e2bb1821fb455a5e3fc249a4df395902c9f05fb089a345a8"
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
class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.81.tar.gz"
  sha256 "074345e5e7019fc50eba6daebf04cb38c5b246c3b3ad1d18bc971f7f22dd1688"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f1d21ca9f55e4b87182240df7d0ad2fc1c8d20e651f8a55c5d05e609c9149cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f09eb439705d6a36711a7fc93fb3eebf0ed9efef1fe90ccfc79cc462f61f31d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef182442bb0151441d62eeedb3d98b2a1a52d3cc7892163795aa0d8e399c0b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff513426fc7b93c891b2d5db7a758945593b37f9ec7e5d004534c7093e8ab80e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dad52f899cab97b5ae5a828dd2fb8020ef68caa4ff71cd889b7c471210e89fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ccf7c24736c01e4f52c19fab06380ea0fecbe413d13133a57ce9c36eb6700d"
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
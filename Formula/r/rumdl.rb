class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "b81f8478cf86bc232877c01f1d475bfa9965002d70b6b7076bfb44533ad97da0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3db34b62f87ed15f38aa570c8810c7158563ae381989275942922de14512b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5243af9acdbe97e1f9160a9b07ff303437428a77a0fe98462bd97d4cae856b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c08e7837855a0d7666aee5c7b093c15919b8ce089bca4b99bfc9892b0f8d15f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae4bfd29725226e606e979bfe8ced11862ce84116d18ffe114bd7bc849b864a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e97807be0d9c122dfa8e207dce7bdde9ec5b10db39f1882b31317d970c9c53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b130a7e779f713e724651595f85a8e742781bcbb0dcf1926e356416ced715f03"
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
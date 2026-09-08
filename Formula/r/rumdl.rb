class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.68.tar.gz"
  sha256 "fba870b781eda06074d19c98e87c4475d9d633d1d42b060a35661c4b4a1bace7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc5eda4d430f8f8e3bb0f867a63c4efb0bae9ba3bbb3eaa9a687330d256e63e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d891d334ed86173a03b352837d95586acaf29e7091f93d9d41cf9dd7340201e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1d14d60940f78b1ad40bd90686eeb0f21fdf071f13830be8b4bba5dce71cab"
    sha256 cellar: :any,                 arm64_linux:   "38d5b6a656a156c92921b77f2d2fbcd3bd3ad449c359288ac77963fe2fdb0f92"
    sha256 cellar: :any,                 x86_64_linux:  "dd8ba6052ea6125c9a4ea36b00b25b746a11722d0bed102741e2ca46ef06b65a"
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
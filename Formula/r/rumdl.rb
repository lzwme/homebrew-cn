class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.36.tar.gz"
  sha256 "6e5fe247efaf15d58aad284c7c0e099fb2f7de2bb26f077961bc5e13d2672153"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "784666ffeead3098c645339c321cbe45fc9cbdaaab021646af35d9ab6bade2aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fe18be09c0bc58636e498777ca01cda205e4aabc0266a8c43e6458fa2a36d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a74bedf5c1bf7762b190e96d5f70b90d179a7abe9b54fdc629bdf40377bb31fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbc332557ba58a9d14a85019d4562becbd440a42aa8870dcedb2c4a44681945"
    sha256 cellar: :any,                 arm64_linux:   "69f44b5e4fc4af31162bb9d21e705637fa30a25893b0b16e22a2031a77df7c67"
    sha256 cellar: :any,                 x86_64_linux:  "026ec9ff5cc4212c27a9e5e386b4024e28ca9e958c260dfbc9745ed6eb2d7225"
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
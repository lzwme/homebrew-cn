class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.69.tar.gz"
  sha256 "deaf3c39ae9e26b92683f1a49e7b3c9fbe3e418f51b469892be541f5e31b4eda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c6d8cb70998e00619a4013324278025ee8ba1972d5ba4ddb7479d93d3e379df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec925a0bcd49e5b145ce93ea3dfc16cab2ade98acecf7d94def05cb4f50a516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f934ebc1c6a2d5d6af8993b23cd56efaef7afe3e1e82f48878a78527d737c5"
    sha256 cellar: :any,                 arm64_linux:   "0ea8956d28403726e4d322c6b8cf74a774fe62f58d1fc2842e31a5ed37f381fa"
    sha256 cellar: :any,                 x86_64_linux:  "82a6a483a66c24beba9daae3d53d294f21f726772a0e3ce07612aa5a6b34a6dc"
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
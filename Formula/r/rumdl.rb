class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.55.tar.gz"
  sha256 "a5a35197d40e3ad840214e673c43c5f47ff7c8a0cb07a33bff174276606d8836"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04daf2fd933591fcf7a8197ad1c2642f207f490b48e58ada61e57009c4a984e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a7c1dbd10acd09fcb1a7c21babcd488902289edbcc7edf9f45cd0b7080798e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acd679cafcc2c490fbadf7c5431fcafb2b123395752ce046dd091d96337e8646"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b553b7626aabe1b8cd07c6d90f53987b8788a089c4aac08962097544c803b45"
    sha256 cellar: :any,                 arm64_linux:   "fdc8a7c5ea5c19143db23d3c603d9381e6860666c4b3aa44908f5165bbb8f1b0"
    sha256 cellar: :any,                 x86_64_linux:  "8b38c760e210ab7debc6cfd94b7eec211d0df4fae19b09f75c20a3b72db12b65"
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
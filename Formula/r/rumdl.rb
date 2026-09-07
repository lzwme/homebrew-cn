class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.67.tar.gz"
  sha256 "2fea6a9f3c04dcf7815d012b63945e7067d0a6923dc5c5db2f97cabaf3f00b7d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4789b166f12e30b9ae4cca9e447d37c04bf13b113ab6994813ec4eec926ce807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d16eec0c9ce500be6acc787f49b1925ee7a706d714f9f8c61e16d489e28c245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cd096f886a2eb7836e513f29f71a07e2073cc5d5eb06a2684b565e89eb0802"
    sha256 cellar: :any,                 arm64_linux:   "2b8d056c7367be9c5cf780b4e3b96ef5f017167fae6b8bae9cb6eb6d7d760096"
    sha256 cellar: :any,                 x86_64_linux:  "5823e677ae400b019770696e07e4c2a8728bca6ff6503fe358b506bd27c71146"
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
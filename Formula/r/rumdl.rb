class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "31efa3aa8e4800d1df8d4387bbd462a506d0fdd4036670f95cec0a5e5de1af21"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d1f65b3bdaeffd757d3e7ad04bf3d61330e817b28fbeb85811be05ef82c8349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6766a5c16049ba6f69003d9b3e7177f3cc0acd5dac6be74bef5925293d8fcf8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc8a44f77c295e1e5ef5c45878eed2e5fe55530a8876ec051ab366a4e7d7a4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "92e60d3666de3a2788ebe55d57783db7800917251fd85cb7d0132161306a9466"
    sha256 cellar: :any,                 arm64_linux:   "2c987676ae3b1bf7bc3551c1838339310fc4040f255eac70338084bd86ceba42"
    sha256 cellar: :any,                 x86_64_linux:  "a31f012cbca04015097fdd8fa27eb8d481a4b5127d34a9c204aa4ef7b6fcf003"
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
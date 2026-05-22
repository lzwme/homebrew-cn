class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.96.tar.gz"
  sha256 "a837d551c8684fb35c92379202ef92d48390db24faf3e30e76c0a5794bca3432"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f39fb1138e80291ec0ff13ead121974e2191bacba506035e77cb97f0b4a8cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d8d2126dd5b41b407882854800297ff2308d27737b85f1ac8d5b785a72d9b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1dad607b000246b58b37eac1b95b978fadc66da7bbf437d7c7e90c8350694c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5682704b6581b9f67ef4f999b4b8ffa958a46c7ab8c6126c0086739a287dc75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb8a006f5336eeecbd16e2f610f5e0c26d76bfa782f15fe19cc0dacc4d0f3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d78ce842c0ce046f3b029e4082d864d36066210e09d753e8293e53f8aabba3"
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
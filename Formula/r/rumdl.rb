class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.189.tar.gz"
  sha256 "affd64541e7476fce25bd198e7de1ccd8996be651ea66bbeeb7cdd0e9da96905"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91a707fecceaefb0262285eac927aa7760b2c9e589441884587c391207ec3baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d62088f9796d29964d6f9c192b00983069a7f86a5c4213428800bdb3f58760d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee97248998e66471259304a5cc598fbf5d68015b3b741fa8052ec761c9c952e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "432fc5829ee60805547d1930711abc140d44fc12224118dd81442f077e4a27a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961e3ea8c59e3a1994aba822f87dbca096c4218951084db59dd2e861ad4f641c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa7ad850bb75dd08749d0103058adb6b0591b736337f3a9a76e18b899c08bc4"
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
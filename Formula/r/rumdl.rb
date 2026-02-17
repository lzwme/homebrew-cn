class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.22.tar.gz"
  sha256 "4c39add1098ed12c1b64a0bf8ecedc838ccaa34ca7f7f826eb8fffc31f390944"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8f84f4fc01a3c601223040eee5c08ae88306f88e2ae4970d06dd5b6bd0d343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b33b03058d230cf9cc7675290efcb4882faf28dda033edb4c0789189c5bdc6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1df7b3c2d6d5373cafb46a79b6e274274f2121aec492b85c3a70bfeca4b90b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f523cbae219eef5d51adc3a724f02da447bb2c5c5738324c56217a63affd028c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfca852058caeea90ec26ca7be49f4bb4b9a6960ebfddde86e83ddb05f261c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18870c1dc8d313060f71f5c22ff5103f7eff5dfb88517a113c36aca6560afd27"
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
class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.185.tar.gz"
  sha256 "3b92f87f232c7b768013606efd66412699ac9cf963cc0cbf8ebf9e00f8ae636d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48320f74c128133bda5e141aca1c70392bf81f69868493af67801688e0505664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95ac76c612791464551f5ac67059dae7da76649134536decc6b424023b6995a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcbad246ef013d9430fdf107db1835fee0d49f69736b3a14f7f4840aa3b933c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6dd9ac6ea922a2eb34cd8c85aa5c97ed3a6ce25516c8120451e0699aad24841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64a961f45a3a20bf0fc63691d339d2d6605327942d5e450aba57bc4c05748fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1169f6996e3eb68c7f90649ddfc0c247d44634962228805df791c5c8719e4e01"
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
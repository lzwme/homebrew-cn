class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "92b62b02bb921f38708d41d4cd29d60a2860e5c9d341158d6e2eb7e30f51ed1a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78baf0ae36a9fc80f76cd4683a2f9c4e207a774cc144572232bd9e5600b3837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff574923d0c6bdc17bf18e5860068b6d30cd0315c7a09942478f8f35847f8cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41f4d22f22e90b64b0ce07840d8a3ad07fd5b8262ac43b839a4ac3bce3c3533"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b5291e8e792406122504c7d0e965241f3397f6a6e90ae97ea0e9bd15b83f926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea8913805b47af46895fe0f195139bcac7295ffa6fa8dc65921b0cd96b8c48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11f08da4c3de81fc7d9f879acb551cad26cb13da14002fc15038449abcd3a73"
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
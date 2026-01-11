class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.213.tar.gz"
  sha256 "3e9a05686053335968f5cc41714679079fd633352c1ab17d19a37cc03c2a5df9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27b228237384985188c58cad4e51681852a335076e8f4d12ff84ed0162cb5544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b43c2b5afe616b94f838319bcba7bac8bf631d6b8d2f51bdc5585037e5bc0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f4c6048e80c9f23808c7868bcdc483c25c8a5ba38a01ae95191cc786a8ae55"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8090516f9588f1f1281eb5b26451259154b0adaefdce9c318ba0f7d8d5519b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18a933ad3e2a097b5bf3e882d18898fa8ea1651ca7ed199d77f4fe3babd0acc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d2a6213c8ee17dd1cf15d77d354de26073266ed866069ceb739ffd9333cb72"
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
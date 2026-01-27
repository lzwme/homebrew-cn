class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "db0aa029715d132d4e1d1291447367cee10df6ce55722e9a4e63d86513755531"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374dd56ccfd3e66e7d1cf32f9f6c80b7120c0e5fd6312af5c9536e3b55b8aa1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ce7401785c1f90c1d06d34c8199ee3b0e3f232dae76552a2b1ffab00e3c9ded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58159d662857f86c0a52e0a1953df9de1f46838bd4b2d97c08acebd57f9d43e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5db835365ca481b5c4c64d6854197516483cb4a5d4b76c7275e52e247e79a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10a7a9e5a390048a41e5781693d1b82008bc8b84a97510e16b23a601a47929df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5488804782ec1207fa5dab3ea485c0581c5fe903dcd887718ef708aeeee40f9"
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
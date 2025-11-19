class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.179.tar.gz"
  sha256 "80ad7bc887bd2feedb906fc6121739563aaf8402f86a7d360bebfd4c2f778363"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ac500964c556cda61554b2a39d0cf869016124d044f62bdf87e49901b3e1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a17d5ff00a3c7af25b970e2e02fddc1d0135b4dbf3893aaca5b2a9c228868f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5d7324663465030129b57ca05256b22dda0efe2844d86fd4a61ff943c96d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c19864c4f653d1798103b7409ad22af18be57f39ee604b9d34badd09b6c10a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9221ec0656a642a663687e5e34ad4e7d1648c582b80b09ea0f9676050d604b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d939143fd9e2e3ab1255e5be570b7d44bcadc1ac96fb147ef1ac34ba5c4db2"
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
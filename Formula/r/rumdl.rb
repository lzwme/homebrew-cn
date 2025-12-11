class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.193.tar.gz"
  sha256 "a56e37e3d2b7f30be5b146a9c8a2a31e6de3b2043f6668f95f93675893de8c2b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b65e0e7ec203597a8917624c1e54989ecd9d406e3496065f804c98823959a52f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae54f962843a47a880b691a37127aa1371b6a7613af83ab7d4342f10c7d19fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124d83e3d2f4f9de24e86830d35870d7fbff078e3e74dddc981e427ff51e3b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f4a441367dd39af2617853bbef2fb24a12e1c9f937737ba75aaf72cc77b058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cd0580b41c81930cfa7f365c3e9a51cb4395a488181937ef8ec1a7c28d2d2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff5970f904da327655dc2004e5610b2b5dd7d0aae31871dd71c728822ba349a"
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
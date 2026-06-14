class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "d7e615012d6c59df79be8bcb8c63e70dc7f38d304e88517c5b61914f92eb366b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b941a977ebee51e6a6eda02594c8195f75b36230377ef9167900a3ec8622dc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9664ba84a4fe29c9356a4b33c3fe3bd6a6ad6d31c2e1c0fb57aec39615432d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491eb1905398fc89e68c5f40c5eac80807b1c4d04d739fa927de2d57ad8acfd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fb03d48a4946a7df9cce6353e0b19a950eb1fc7f4291f4e59b497a552113ca0"
    sha256 cellar: :any,                 arm64_linux:   "7ad00115afebb1bb53543b6d6d2ae036bd8b03381bcccc1eb1c0b9eed0e73e19"
    sha256 cellar: :any,                 x86_64_linux:  "1c1d65d0983815ed1ac67cce5ab05fe43e0ffddf493f95ee03cc4e2622d1ca92"
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
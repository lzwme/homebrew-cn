class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.197.tar.gz"
  sha256 "c78f1de6dfe6ecebf4517255c55645986592b91e6c69dfd87c157db242708a37"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d3376ce07ce79e9ec33d87d9648c3c5299f1a774d4943d65aa32404592236af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87399098c3421628297c05369671005e2d90b0221a58d0816ae261ade5ee6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cba602d730847245ed0a5010bb29c4e7534ab9ed840d6c0ee714df4002b723b"
    sha256 cellar: :any_skip_relocation, sonoma:        "455b0e2ddfe8b80adbec41bfad3c54adc216887420cb4ca868ec32f97b857f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec2f62818d73a80c42342774cac0ae9988853387c8f258d99dc9afeea6938e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa10ffac3a0be2f2af9b681098bae78d44aa738fac4c4cc5f71556206377416"
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
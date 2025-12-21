class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.198.tar.gz"
  sha256 "d4266edb93ff7cda0b307e0697246b3555d3e4675f7638ab983d8478d2b846f7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b55634e47573b7830d1d2e5faaf117d118277e7049f5c31e6d508869262b6db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a686d14605601728995a648dd161a8fce58e6207d9281c6d5653c87d3003f690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d46482120024f18b10b05ae53375323b7703dc2569b482a54e519c70cdc5e3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c78596a1bda73b968366f90dbfa17342422e6fd465842ca11e6b5a368de6b921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "477ee3ff42987fcf377ea24702466394ecd19bdb8b0b5d9052792cafcb0571c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8776a5baa1531094b843760b2926219b3e1cac1ff336644c540bf6d983be2061"
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
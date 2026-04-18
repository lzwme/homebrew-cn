class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.73.tar.gz"
  sha256 "206210370de555bd917c5d22ea1bdc702991cb41732da29fdf62dd52b0f1e3dc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd5cf211ee86ac8005bbe83fd39db5cf2f2860a733b09f31cf3d11c19430e1be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d55227328a5b44b25c7a15bd5fe707874ee6a1a5005641378255509873c6037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42626761edb6997369fa1f562460ff7d0b5c373209059fa60b15437db6002f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5778f507bcd4fcbcaf04c990e864cb36cf585950879b70eb1290193dcf160ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffce9dbe800f9810960ed1c98cb6da4f0e76cdb3ddd2500dc3eeba7f3979451d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb0f69cb60c45340e92f543ae35cb9fcd705deab3d903b579c41fe09b2f7de7"
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
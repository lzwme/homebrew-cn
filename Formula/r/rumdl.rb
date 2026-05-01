class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.85.tar.gz"
  sha256 "05fbfa303f78f191dffaab38a64bc7106cbff245a31f24cb2ff14efed3540651"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af3301a73d7189e1b4980f34c37770cef9014c0319be13f34219c791a88c45d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfeda13cdfa96d55bcccccce7d13fadaea72a036ecc152a2e5ef489c7c761b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9877647decd24ec908f96d5cdad08d743dfcd428de071e0418dbc6639b8654a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9caf58328306a88008de110443f5540bd4ef422728b49fc8f66a44b4a96a3dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f1391857a909697631980cf2754462cf80bfa12bb8f8e6cebace3302158e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b1da71a70c734b96c66fbd284a495ec6f93993443b0fbd1b1a60a385add58d"
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
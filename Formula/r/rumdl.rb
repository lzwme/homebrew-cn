class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.224.tar.gz"
  sha256 "fc4b1db1fd42902e079dcaab044b4999971232af9607b2cadf832d102740b58b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e7c6d8cd1b7897fd6b639620d8098687b7d18b0b3de4817b4117a6863521b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e944b0505324dca6b734a7bcb61a0c757a24930668234239be4116e9e26eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d574fa9348c5a58a286b5a304eaa1558850d1d58a0fd4b08d69fe3d45c403d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "b24ca97edaff2f0898558cd9317415b9fec893b4e34480f935ef23bec8c5d391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71869d4b0d1542bd940604d2eec426d16add8fcf0eaacfbec5c2f012a1da7a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503fd5eea4be1b5ac8d66e04fadd6bad92f91791fbbfcb4d677420272e6556f2"
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
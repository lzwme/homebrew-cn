class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.174.tar.gz"
  sha256 "08836cff504f10bba37bf556678b45986b917ae9da0298fc2428f15d120fabd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c011b582d14274f29a5823a6d298a1202b6f36c57168b005ebd04bd260a196f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dc462f7c32b1f6c69318279706cf68aefff9039bca3277cd84118da5b4a9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23e2039f764db1031f9737c04f61d04723a913b1d8c13dbde41b3a9c0496288"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f9e79ed821d11d5f3adb6adae242b0ef20692e88dbf8201ed15d31d37e3825a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d49768fb94aeb9179ba829dbaa69eb4a1547d615297846142c579bd4cd054b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab64475b1c87fac39ecea3f282e927c684668a1374104a0d3a04aadfa99b30b0"
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
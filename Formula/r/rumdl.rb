class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.38.tar.gz"
  sha256 "eb4f6a56995a582f7136381e204822cac6169dd1bd5aa48ba3344d21639a281c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8acf4f747b9a6b2e33f0aa3b1f8da081df87199a2ddd9e4654af2f759504f893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4009063f5733ee6fd351555c58db11ebad4335f8490480c809b149f92498050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b913222cfab3e3f9817d19591f2f09ba827a4ab3fe70a444b9d10d2e60dbc98d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b57b31ab48bbc418e203db07ba8ef36a6b6342ba378a3c233e514d68e19735c"
    sha256 cellar: :any,                 arm64_linux:   "ec7031ed7ec9b383e40176411ed3215d3a769a67c031ca63ebdd32953756fa0a"
    sha256 cellar: :any,                 x86_64_linux:  "67d5d00aa5cfc78f17f997a7494f58ccb2f22816e8b8fd639c6ca08bc4c2cc30"
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
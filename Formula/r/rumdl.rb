class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9b852bf6568e62b678039c23eab67baf2913bfc1bf0d85d9bff446ba94652155"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bc87463908b1777ddd052fa99c650c050cf635162c8992ba3c70e0d850e3fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "013f5a9c372d13b008d2027ac12b2af2ceec8d87c970889b0f30cf8ce81a9384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20ac7d97af89c80683cae3a8bf803c521145193f7537bfed0a0b35164c7f928c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf07f2f27d28e8d321f1b67ba66773c971919f20f63d2a8e01e39580590c063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a089405bb8ed06fc940e272488761e6b1ff607b7ece96f6db08555295153ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1790ba45f762806cfc5b51e79283501a4967e0834ce2b97e3d04d9835b76cd75"
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
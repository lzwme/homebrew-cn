class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.200.tar.gz"
  sha256 "78922f74987990f42cc237a72c8b0a4381fbc77f80abf54241ddb6a6bdb772f2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e71e6c265badeab5238a71c45ca7a0a8b81a311cd160df5d80558d7f532e0b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ffc71ed33c35d39268b98168020a12dd301b13cd297cf7fe8489dbead582e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114e0f03b0ff1c49a6f0465bf677bad8a364141172c8548df1e931af1d4c249b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad23bcb4c87173bf6d73bfa7009c7b8574adcd3b7cc2af6ec09b7581f0585fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01aefc169c901226c8ca8455337228136f4d31221ca7816c931157c54691d285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0074135032f32921e743588c1a4519bbe6901fb5409d8ebc9332964d73c71a3d"
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
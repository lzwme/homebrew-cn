class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "1956cae722acb2bbb54bb7fc3f142cb9f76e30c37f4eea0fd20be5237558a3b5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb03565e371930c74a91b5e92dd9697bb1153a5442569558c62702d302647870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d885f89b88b758970796458562e52dd73d1405ad87fb5e21f888f4cdbd77d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fad6c98a59e3b7f82395046170048a09bcf1ce543fc8042eae8fb5cb4dc7819"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc28ff05f44d546efc9e075a360694e28d63993a75f559af9b00a0c8e388c3f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66fb3423a209e0f3ecfb00cc9f66c75d02fbf25b4b1f0b8df10dddb83e346071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6590647f86f173d622b32bfe57661a8ba73a4cdbd5512eaa934e2b9d8b2fa43"
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
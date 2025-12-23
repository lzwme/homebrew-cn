class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ccc408a4f9124cacfdb76bbf9aa42a5950b2cc6acebadca9c8dd0f02c70f4104"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d8a1a9c164209f2b7e2e793ee514396eb299664571a598d09e627e4cc75c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c72f6dce5e5cb0257edb5d7c261c5b4b7ee81aecd8245cdc0dc894a4457912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ddd5ba8a8a1872a3f7c2bbae5c38f9a62358777930e058e11e36c1cc9ccc3e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdf168c47f0dfb893b1874f2314e3fec961e1f17af52f2f72a25a4c7d7dbe94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d49b6285765f24676c4a24be6697d55827890cfb3009990bc2df3c6e08bf7697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d3832021048caf901e93f898f11685f50aa002a130b17b7082a21ba27ec67b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1", 1)
    assert_match "test.md: No lints found", lint_output

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

    # test harper-ls
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
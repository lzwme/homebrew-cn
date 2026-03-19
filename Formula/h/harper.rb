class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0cc6745da3cc1f8e0909d01ceb611c89a4ad58cb913c0063f0e7bb89230ef791"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5afef314bbf004cdcbf4cc7140c7186615efd9d614e8d838218b56769500e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2430f136a5a5f62b7711f47705d867b81970f9fad54ca22ac8c648bc061528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131630637305d1787c2c709da66064f00c0094d2846ab8b5a6fa00632d691034"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ee78adf66de318425da489b1462bef8a0cad47637f16d9626ae1de02278efb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc710eee2f52e6008ba325c3457d932777e1b110ea6bb583cc19ca3af4f78e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ee900389e17ee6988e745b2a4492819b47babfd657095331327aecafd51e1c"
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
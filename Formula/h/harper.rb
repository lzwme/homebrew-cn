class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "37ddaa7a76738d41914b6235054c4aa255b5c029f19e42fd4e44c9a4fa44daf0"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8698f5a6d0a766e9fe4c3bee6dc4457fdaab972b54e8d4048597ecc6f643c26b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "482087f427bdba5a70b9211b790efbae590e2472bb58aa4cb61f2ceb2c2f4c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44cfa710ac7e26466167b4f9fe1f1d2b6ce967edd088062f9b16d0772e74d3fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a1dad7cf547d2bb3e0b2d3c03783aa46d831560d46adde870907e8c258f18b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95341de19035942a16dfe14a18549ae55a1dffa30f73f390e549f5e4fc60fde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823d59b9613071d54db5618cc7a5cafd6da3b05c8997132c9484eaca322fca38"
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
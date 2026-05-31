class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "34803150820aca1e254736999ffb09820a9332e0135cb895a7a1b1210c65ffe2"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78d6506a2de03d4eaee3968b3358507f9ee456101830e86a7b6748247277f475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9926e1e648f20c80f3fe7fb4596a54fb74f1a0df53b656c792edb349ec721403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5302d45a845a2d2c70f93135d11a4b3743f5a61179325b78041199ce662bd86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8499951c9f4991d1b1d681145598488f69647accaaf0758a1a9e8fb0b952d45"
    sha256 cellar: :any,                 arm64_linux:   "6d2d019ad5c8472d7f3bc42d086d7a15e2920ffcd7af61bd2e23c39294271776"
    sha256 cellar: :any,                 x86_64_linux:  "e47f7c23e617bb9d328d4b36638b217b0338ba362684e6d9553174a343c5be46"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1")
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
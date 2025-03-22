class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.25.1.tar.gz"
  sha256 "b444d052e13255fff3e087cb6b02de2bac9410f5373370ece36b74412849c599"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75463040eea4df0b682e17fade0e51bbb09276c2ec328352962f6b583da1100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29a2c55f15e0c230ca7f353c53415d80e0578760a82bac8f2b47844260ec623c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de821a284292e1ac8db4f31f7f273a438431b1af6479e51febbbb1902c7271b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee9a9a3a674e1abb93a8cf4cdf8aef09fef46369c7e25da6516467e96a6aaa31"
    sha256 cellar: :any_skip_relocation, ventura:       "6390891c9979a7e5400b0d016ddb4b2f5f4b693bb69b161bfa1d5302d2ca917e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8bdff1b09dbaba7463773382bdc12136cde9cc2b8cbf1d63f594f85f3eb377a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a088a3a14ffb889e1533241d40133a25bb9dd15b11ba4547514ce866b559c69f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    system bin"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}harper-cli words")
    assert_equal "\"B\"", output.lines.first.chomp

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
    output = pipe_output("#{bin}harper-ls --stdio 2>&1", input)
    assert_match(^Content-Length: \d+i, output)
  end
end
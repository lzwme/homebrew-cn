class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.25.0.tar.gz"
  sha256 "9f3b93e67b29ea6822fc00eaef97afa134faec6020a5447a1d6e41d1ea7c4367"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bcd84ba09adc2ec8c92dcdeb94c230a27521e45707cafadb3640a612efe2c3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2664f2188976d9b2f5e4a5937ff8b0aefaa46c25c86e84e1d6d9d0b5d2a6e645"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b964dabbca494ac67ea3deafd663d9748e91ca16ff9a3c4558d0f5ec0d75cd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c92142dce05b79cd646da92be9c52d0e443436b9ec085061c9f9401feaffead0"
    sha256 cellar: :any_skip_relocation, ventura:       "bee6a2a51c8bbc505003972d2bfb730aa713e211470060bc278e3e630addac66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eaee0e4544323d6800bbc6399649ff5c43d8efb4d72983a8cff1d699dada1e7"
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
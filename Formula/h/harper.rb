class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.20.0.tar.gz"
  sha256 "3b027e49ecd5196117d41075fc7e849d76ac25fca00ecdac34a5c1ccb4408606"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47871045ea10ce7dfef39c01822e81df5a35643f2ea0ad4c15ba69c87dfd6eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1bb4a91b676b4d50331b05a0bcb18f0c332375609d1d6aa4de24bf811d328d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7033ea615b0d2a58e0773254eaa5c4280b2190d7c087ae17a06c8c79223ad3f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e273253b59d53a7ab267f692647dac64ac74baad6371c46b101f329738f2d7e"
    sha256 cellar: :any_skip_relocation, ventura:       "fda48c3a4c3ee713d86ddb5ddd8c6b0d33ae43f0fb801efdae1e301ac1ffb2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b78e6bdc8f17184418ceae9e4466b2da6375b10ca68cf47a4d0af093b0d0ea5"
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
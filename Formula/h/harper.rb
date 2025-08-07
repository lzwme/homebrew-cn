class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "84ba15d4c2870cef56a7e8eba2cb006cd3d18694e22ab3a9760c0c9dd05d2dab"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a10c6f312220360ed7d26b2dcd5f6316b1569fe791c5a5c8e28319beaacc6c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3ab30e4fc672986c313c7f997c29f737b89774a07487d4b4e00248e612801f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d7f635ef8918f7889babad3f85fd5ce0bc19a2987b32283ca33b3bea2a0ace4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d65cb23241c51cc16b95a30aa26f7d4f214449195917135acdef07ce0bd3802"
    sha256 cellar: :any_skip_relocation, ventura:       "c700270180c0f7e7612c8804d4fefb97a33b50de2e2d14bf999d3bf06756233b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ac2f7bc31a21248a7e03588e83b063265f18e31eff6c33893c661851cf990e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed95bcf88996beb1292e53823ac75ac2b3a6ad0f8e3274cccec9beb2956c3f2f"
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
    system bin/"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

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
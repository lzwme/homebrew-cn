class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "ce194eac289245857fb94380f7c6ccffc4e859456ef863169210f5c18e26b6ad"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee2e52fac2dc308045f646bd41acb293f74fcc5d7b18dd670660ad9ed48d9d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a86b2325339676ce92a4aa1ec5cab12a8352f1a78c0385afa9d7ae80240ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "481500335159049dc6706042d88ae18dfb1fbdebc9789aa8da59abd936c7ffcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfd979293a2eb5c1de8731c9ebedb306fe8d0d1114390040f8b34c328956a4dd"
    sha256 cellar: :any_skip_relocation, ventura:       "833e7abf6f657ef6781c401073d1c434d50b96f7ac1304fec75dd3d268f4897a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc1a144e41e3f1dca7e09055801431cbd68e72dbc149518b2648a36d4f0f37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a276172b130c0abebb74c3d91e4b4c0fddd6749093794108440770e499ceef2d"
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
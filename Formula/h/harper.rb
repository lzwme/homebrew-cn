class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "cba564039fcdfa25b0251689a41f1343cda4e71ef55cab19b215bbf9d17bf725"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6603986bbdc55e8e39c1bfd20bcd0bdc26497588c9b7bb84e39c85dfc978884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5168133557a820baa574ec3b81604f09c03c7137579ba524329433ab2eafc79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7f06ae8b717017ead314367cf0de23ced5d690abc16e6e1ab2a7de8a34be3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db09da1806ecdd25f9052132af9761dcfbd9440a7ddb669b6e738323ad673cbb"
    sha256 cellar: :any_skip_relocation, ventura:       "cb5a1f6ff7b717876f38f882123a030e7bcdcf7a7cadd97e2a8b307acdd58415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08155170715860d113a35d93bc217d258b5b17dce242f3c5c9e10061ac766b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d7b04200743915f497c7f7d5eddb47e718980ce505daa3ac28fe7d85507d507"
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
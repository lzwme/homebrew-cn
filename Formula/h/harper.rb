class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "8f02b263a7442138a3437d5ec8953aaa85a491497dc63d69b1804528ad84fb5d"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbaa0e8acd87e9289432441215d7be4b9da9dcb2b0d31b0076d8922c3f80875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775b392d31c506ab6d078f59fcd33493b7ecdec1ddb7b2089b20f2f90c3e643e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59c5112e688f640498ac89b2ff5f6b47f5579d43271e254fc0fab50504ff49bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "17298d6fb43a8f2be5d09a0ff193dc86edbb5dc231dbea0edc50a25604e7b176"
    sha256 cellar: :any_skip_relocation, ventura:       "57740dfb75a6fcfa85c48242e119a256d3f8af1476231aeb462a2dc4a350cbfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b466da609587b2a2018301777210e8bf614f7d5e5295613f579210d5b47009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b3172bd99a474c52f7516b7d09829fdd88924850ed4540deb1440dd15bb4ee"
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
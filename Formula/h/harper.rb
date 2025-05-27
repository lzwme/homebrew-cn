class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.39.0.tar.gz"
  sha256 "bdc4b2fc7010cbb312820e85272ebcbcafebf5da6b9365d13b23cd1cb2ffddb7"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9494f31a42e2d96d0a5d55051f4595aaefaefe8c293556f7151b6631235198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abacdc1bb941c4acb71a765787914d82e4b5e0e8d2d67a657c2cd4c6c0dbd510"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0521c9e6c84e3fdddb8f78d80f6463b562d17ca6bed522bf110207efdb90467"
    sha256 cellar: :any_skip_relocation, sonoma:        "169b2e126791c66cf147241ddb2c4e42ffd5fb00624fb1497a6af6885484ac46"
    sha256 cellar: :any_skip_relocation, ventura:       "ae39b612f3b6d068c3334ef394cb478c6d46d767b16a50adcbbf6363aa758f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85f89febe6a70cbe90473f2d978b7eff5538ba9823373208b73a4566b5853758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db021ce86683fe8f4789d83597dbdc367ca4b4a3e5913899fdc6f48321289cae"
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

    # Dialect in https:github.comAutomatticharperblob833b212e8665567fa2912e6c07d7c83d394dd449harper-coresrcword_metadata.rs#L357-L362
    system bin"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}harper-cli words")

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
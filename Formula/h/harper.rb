class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.41.0.tar.gz"
  sha256 "6e5206e55bd1dbaa3127fe73413d90f2ea62d2e0d906e1a0ecd45e6831354aa9"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87fbe798cf75b34bb75cc3a1bd6a6b767185c552cd1661021fb631d6d9bf6490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfeb4db4e0993344a4b571df4322abdfc890b84a0606097684f129653b879d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cc69f752ded2201300b9e7838edb39cf73bc36b8ee47b86334eb65bbe648457"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4596d6d9fa9d53d1a2aa7b4b736f99ddbcbcbde5bba877a475aea787a406fd"
    sha256 cellar: :any_skip_relocation, ventura:       "144be34403f638bd570902318c2bedb13d67d9952a8e17c2b540295f38b6c33a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9fcf72414794baa4a37ed9c63f4f31668158dbc042727831f603b71441d005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5cb9c20dc692e5e416d82d3732d08720bda0dedf0ae8b3d01553faf4910131d"
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
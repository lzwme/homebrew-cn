class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.43.0.tar.gz"
  sha256 "c49eefa86b96295ba033c1ab4324d195df26f3caec48ca885003a86ce64dcb63"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293d7596af2b63d19f1b1eaee3f46fffb374f84aecd5c49e4fd68a152acd58b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94242542d6bd8134db896545999d848392668e3553d20b5818367ee0f3478d85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cc2fd693ce04ebf2a5feb6e3f72dd87501c59b6912cdbbd764161a401f0d05b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b93928e41fbea2bcfba85575bf5a78e6b3edd58dd0453df0fe3ac302020ef61"
    sha256 cellar: :any_skip_relocation, ventura:       "30b1d771aaa7d7bda1861673fc4f4928435975707ebeb5b9b232ec61d50011e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9d526faee47c5483ba02f3e6379c7458ff2d715c69dbe8f47a8d755f6407ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d05d140930d4219f38f23c39161ed32670f4a9607a30a24041ad586dc45a22"
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
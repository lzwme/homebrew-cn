class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.31.0.tar.gz"
  sha256 "3eefcd5cf70c623aa571b9cb5457f8e317852de47dd35689a5d7eafb62cfa195"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14f39f340194277a3cd4004fc3426df3ef70cc50399f0b08488ee93491a3cf5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f35e18893bbca3268473e74f8b775e317832e4c05db17833fbfe1340d8532c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "434a1738072a16095e8a8b9439390c92f0ec4fd8638ccfefcd7221cc766665f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbeb085c3edf36d64197f528b0f9db0edc98e50cad2218e07e6287190a6dbb50"
    sha256 cellar: :any_skip_relocation, ventura:       "7755c8df881aad51658c643b7c1e91492e420e43411c755243fc0a1deeb01b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75ff1802d7e26713f19ed71a5bb90a2321b3ae0b5e6d42355ba9054eb9df19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8e9e8bf0eeb84ceea140544d60c7b1fd1407d7c0b88e9bf3ecbd767f5223ea"
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
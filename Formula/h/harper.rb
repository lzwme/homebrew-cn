class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.46.0.tar.gz"
  sha256 "136775918972bc6c3a4659073ae759033a5c7622b02a8b34450193c3a58b378d"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72108b1a94b17cc6b443bdf9eff4c53f9241757a4faa2786f80120ee4e8a9409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d06655d4bfa8cc236801b8c227092d3c84ddbe21ff0e20935605058f15f6a98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a9daf10c11db10d4c43b4aab02dc2fdabb5c2710aedb12206a0ccc58f495b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3851825d3a385ad00537d56223c87dca953b92cce2585e8c37560290629045"
    sha256 cellar: :any_skip_relocation, ventura:       "a58daccf5a33199327e5e5f967ee5bfa564eef824a8ec905743f2e2acb51a234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f082b5ff23c191b471e27f1e9c037743364b21f09fef43e1078c9eade3b9d58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42816845e002733185d8e781b2e8355a4ecb071ee6c0cecf9d1995e39c728e6e"
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
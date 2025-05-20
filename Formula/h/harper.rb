class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.37.0.tar.gz"
  sha256 "387f3974bc49a3aec3955654e2c5748a12c6c25137d2b86579534b582839a90a"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88b185352d0cda0b834de7e5b37dcafe7f6a06d3ae447d9b6ddd358793133067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c856adf8e94945c2658c90e2f7154ec98de2d7795c7fc851dfda44dd9537578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce94c6b61e5d2e4d40c61ea6b4c8078ac34b95c686e16811f784276ce0b282e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f94ed5d9285bf5b6fb4bff3c26c4c23ebbbcc188550553d30b353079e59a69"
    sha256 cellar: :any_skip_relocation, ventura:       "a9824bc0ebc629bd04e9772b8998695102bde3659fe18fe9e7983a8b6dcf29b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2d31db61bccd9213cf31976c6004928c2673d173545101938071a69763f00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36d2cbaed9c8744fede7a30fda7839bcddd7068bd9230b50fb87c3d2379dae1"
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
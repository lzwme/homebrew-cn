class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "988cf1abbf5f4ddd85850e4d6a13c60a0dcfcbf4af01d9d72cc8c57e8e076956"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c112d1fdcd6b1926c93e644435945f11ce91ad98ae9afb13ecf963c6d54d9cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c6fbc2a51b4d7b6f1bbf9ab29c0c30892ec22f0b91edded56429a042d01e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8577194a52f30d25e87dd77745fdcbc1a0dc104604cd39dbc0a544773348770"
    sha256 cellar: :any_skip_relocation, sonoma:        "b363867716d361d503940911a2b7201bb3f599f2c30d10ac1ce6e9f9f0b140c5"
    sha256 cellar: :any_skip_relocation, ventura:       "284168b2d65b8f644c1e8d209ff017f1f95ec4b70c818689a7234a9806f262d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e00c3b913ae7d466ad89913beaffad61899dc7a6539ca2934c440cddcf98df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75b2d5d077b8e22af28e9f3d79dc0746b74ad3273c4d56d7b2759ee4f882c48"
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
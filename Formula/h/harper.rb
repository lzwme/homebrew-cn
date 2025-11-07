class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "18c95f88e7b72d0bb0da02104f6340b853731945de1c7073da831502908b383e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef8c9736afcacc49e35090234975140afd5306cf7afb3f6ee14a82c215895806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a377484d4f5fc624a768498c182de7e963486113c3b11f84c42abbd6ff5cc06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70884582967bfeeb131007d80b5f163838235c16026f759a49025031cad12371"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5522bd4baf76806c2c9befa93f95e6fa2dbcd3a262d37f9c9ff31c70e27e4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bdaa47ee16dcf44fd330365824783628b7459363d8eb102e1cc0683c68e0f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889ef741f02017303162f2054c65c29ab8a0d437cacc9d8ce33bf3625cf6a492"
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
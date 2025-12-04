class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8f840285d7ae3222e67c3b858822b80da66ebb3ed2b35693fa045f2c2afc6817"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229b279b1c16386fd5e330122e9b3ee99b6b4a6b950d9a9b07abdd5918bbd3ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "769a20edde833f97dc1d1fa82c1a94ca6a9483f605faa6e85150a981e0c2d253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "597160ab9e3f86c9e68c29c8630c67fce4443b7e257a944332a10590c6c4a6aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "383f0efe1a4361ed5fee833f07e8a960ca7c25f9c225e7683310a7d4ea0ed31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1310d9a6ee804b73b4ce22e018ac181a3a2d23cd2b7adce9eda13685feecbc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5dd2195fcb99397073318698bfe8753894d5f622fb671efc7a79af57765310"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1", 1)
    assert_match "test.md: No lints found", lint_output

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
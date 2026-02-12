class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "da56b2fd6163f7bb5e51b43d8658a402d3773e708eefe8758143301285a16959"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e193397aa4a7259174760b892613e0bd67c1f67cec7bb9c5a90e94eb013622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb2791b5d812ae0acd9e692e504695d046ce2b50ca92c6c0728e42bb4c2b475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7d16f7bd12e45b294ee597b5b8c82f91096a112af0912e6ecd07ff063f35c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecd7772dfd530aecaaa743d0047dafa0312359e4e951be430cd5fb0f21d76f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4677f1ce90b8cde2180479cad54250d7a09bb59b3346c660d4b7bfeede3796cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0292ca7b935eacb374fa3b8c96ed98a83914e6f9ab7054c9d5ac3a31272b5f59"
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
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

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
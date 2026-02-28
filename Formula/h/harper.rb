class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "bf7d71214ba3b6f878e7dcca72904a93d06686cfc5d59b7cad3dcd7cbfe5e94c"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ea04affdb15630f13596822e20b0e14572069982d98e87f29a53dc20d6e1929"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541f8c22e3feac6da48d2e540eb50450f2bcfbc549d0cc3b02fa027aea09a942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a4278d07eb230440b3f2cb65b3d08d5570645afd64246066d10daa5aed47247"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c27da867e77d27fc13fa88eca19b910bf401f485520b08ec5628e49b1b7e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c086205a416f2d3352a0759778f49d06b9b7848c18749e77ef472ea08758f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f977aab58b66dd20657aa0f363f5082f5b1c5c7b25ddf7f9a97cc9a8562e9e"
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
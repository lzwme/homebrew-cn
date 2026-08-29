class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "3b8a751b93d09ab8f38f1dd47f88192334fa73b3b448a0450b1943e74b4d75e9"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "147f4dbb1a01b90a78e1fb49d55a19253c511d33bb38a1970bb09466ba2c8ab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e60088ea2ad8a3cc9ff954c53e5490e5b1898bb545614730c5445e293c804e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b145c6355155386303e5ff0fe0d22566649584218f8d5cc2d60ef2a67e7e879e"
    sha256 cellar: :any,                 arm64_linux:   "f5ebb305434efc620099f70a3ab416a6033f475ff8f57027b343ad000bcd1381"
    sha256 cellar: :any,                 x86_64_linux:  "89ad45a812997d90ab73581690d1802e0dd11d3c628a513184e6c69bcb0d7909"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1")
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
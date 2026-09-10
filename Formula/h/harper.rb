class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3db3c8233ea33b1ecb05cdbc96d0f3f16a22dcaab2dac0f26289f0fdce2d68ca"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37523c060e621e47816eebe01d3becc81f8095a5d7abbe44032e7607f64eb69b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0e54ca151feb99b267fb3aa0296fa8ae4b8baeb7e6bf88793e0caad0113bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "416f23a835b4999b7f4ce569d0299288a168537f4e5e39f5ae088dd72132b8f1"
    sha256 cellar: :any,                 arm64_linux:   "750f4b02a9abeddf018721ab4db2c1ec681e72146a9d21d4d541c2c0381f5c9b"
    sha256 cellar: :any,                 x86_64_linux:  "04d773e41e20ac33bc27e28e7a3659472ab14273fd4a47993661f377cf1ecff4"
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
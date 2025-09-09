class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "1427b543299bd99a15d0ca29a1f9ec9e301b3965af73e2c6068943c678b376d6"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efadd023eefa139ef967afc10cb6286ebd2396681cb600ecdab23b275303f373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a4a9fb694718341dbe6b0d260ab65a6c8f9e5b4f9cb87e9726e6920a4e4f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c2798d903ae136f529bc4aa9f47e1be01480b8a3934ee8c179fd43775ae3c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "46f970e0e3b86cd8255406b09ec061b58ee4fce4d87ec85f8d99d786d8313988"
    sha256 cellar: :any_skip_relocation, ventura:       "131594d6f87b6127efbcceb2ccb6ddc0a5576d8a767b8221415a6613906c8343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12157bf392eb790ac7240e956208e990767b1493b3b9ddf0d17a2c4871577b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d850496f0ec4fb33562386fd810c11e7a909535e479bb0c0f53a7e1339119d"
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
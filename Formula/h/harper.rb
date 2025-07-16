class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "57c39f0f5c24144f11dd0f62043b0ded9b7efbd0efc785ff291cef9c54bd5a2b"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be748bd84a4155c3496808db5c9489db43f447bedae8e915cf14ccc4c0f88953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f3e9aedcab1723700ca33ebc6fcee318c0104f35a129198b56143d9d984d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e7d3176e56d5a70e340b87209a7fada36cb5c9042331a0e09c2535d1f75db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88e2ffaba1963cbc6f1ac1f64f20d287934d1a9516f6aeb68f25fd0d3364b7f"
    sha256 cellar: :any_skip_relocation, ventura:       "889f5ffc646f916ef9ce2b527bb2c0399267baf74a44e59a26ec9fe120500d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0944bddb16e16b6a8d635be7a7c7030c095f4edb40f6dcbd7984cb9ab3f032ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3b0bc6f75a093e6f09e07ebd1c74776c5182850fb1941748dc8107f4bf6d5b"
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
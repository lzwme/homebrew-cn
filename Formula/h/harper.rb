class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "7b4c398803385a9dafa544c1a7d5aaa35fc1e956c1df7c7bd9b5b484dfe0bfac"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6209a41bf28311b4df9988e1942f2788b775d54a0bb7181aab874b42282e5a2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9b88bb3519c8ee0da83c26038e7122cc7f58293d02e6a0d5b39047135277155"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb9326eaed841b756fdeb4fa798fa30c8972bba9c41a9f8d1e416b0f7b189638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52629a2b58fb3922f3232638548df4486191881a3245e9d85d4934072f245a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217de8c1f13c22258ca39908e608dea15a8c41c74687d916bb1b13404673a12b"
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
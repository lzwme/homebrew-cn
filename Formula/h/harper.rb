class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "86ebe50c09a8e606431cded973a0b259489bc8cb1613907e99ff686feff2d34e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e32b6b9f9608387d6bdcc51e6bbd779cd76ff392610fb878533e73906e9a9ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19dac952187440ad6ce8f2ff15cb6deea34b7921861ec4e087adfe506dc7fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68feb76fe2808006e12c08a45c0bcd8e1f9159637af24c9f51d3da11da4b7f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d77313f6cfcc4e1dbdae7b02874ea79b4d13018e200b79dc3de98ea67576d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e3dab342a521f79baea5c934eb1447979e6459df465be29917b675eb630a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87411ffe5f6037fb914eac4a343c33557930f9f777d77233d1ad32a631bc3b16"
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
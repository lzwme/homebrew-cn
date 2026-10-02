class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "157ef5ab41aa29b6296c3842c5a31f9a4f24dd37adf22f785b315fdd577784b5"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4c21653f90ee370a6a05f6637e2e871fb8d077a12bed28f167af250aaaa9acb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5efd5a9d872e185ee2cc64e67cf4f9ff3350934d8567825714eb597e8a139cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f806152d02f97df83a915e571b38b8f86f0f5146efe44501671abe52d4c52007"
    sha256 cellar: :any,                 arm64_linux:       "44cdbe3979fa4f54c8190c0668906488a6ce83b1939e353f8591e299b7552afe"
    sha256 cellar: :any,                 x86_64_linux:      "3ba24bd3b5adddc2818326c38b149e1e0221659a321be3ed991899c1e7eb6c36"
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
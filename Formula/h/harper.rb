class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "3fe25094e42d7d67483fbb52f0cc6558adb35f9198a63508cdb5aa4418d3fcab"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6024303e3ea549141f94d2dfdeeb5792473eb69b44cdfacba923153e08b3fbf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd9fad19dad0f5c67491c97109a9397a0e6b8e12b0bec1d6f4172c6fd1acc5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52b5d1834459071877763a0f2a6cdf585cbbca1d5f4999233bf91cc11381a787"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da74b85063bd616871cdf6221ca115580c0e76f43ebc8294ff88bd4d5feb2f3"
    sha256 cellar: :any_skip_relocation, ventura:       "559e39875339bc776ad1bd734263cd3b7a2be2e315f7bd154ab5fed223c1f11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706a22e47ac10ea629dfcf524620af2383b92b13bf41ba641e4d8943d93f05a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a80a87d08081920b3327364764583fcd3a0647b4ee35eab3273209310abeaa"
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
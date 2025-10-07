class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "bbdb0235ab6214923c740defb1b4f2e2bf6e414e941c725f1a76ca49feb78e5b"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7ee0c55532ee6dac0ec1a0fd89b5f9566747ad342f2f73f3c45d08524d34399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e337102c8d67a23346e76827eee11b59a33ff7e3530d4009ee95e268110c6471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f34debcc5c8169bd582411c0c38826a392e8d56a35d6bb02f3dd51d0433e5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c77244877b1b77774a6aabdb2130d7cb9bbb8ba6780bb953ccca87a3b9dae5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9beac3b7509f3027f360e8cdd965065975bb0549bab3a0a725d253e3dcc1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367ad44b86724357f88fd987d9c11f0cfd23ef35cbe85e9c7e766ee1f412b7bd"
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
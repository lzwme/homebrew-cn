class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "351af79205e275b62900204f04914b6445c29eb8dd48883ac67e018d8559dbae"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f6aebe5c5950fafa0c754646f5276ed01fe6a172aa4bb0228e2ed12d34b8647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26ba93706ce01396456d15ef9f22305a909c5ac853b1e54acef5852754a9d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14109ff6e337116e9c18cd73000ea7f6398a6ed929f642db2a22f5c23b80f22d"
    sha256 cellar: :any_skip_relocation, sonoma:        "efff2ecbda3de2f76017de0faa6c33d697620fc51f543422c94373cbb66a6e19"
    sha256 cellar: :any_skip_relocation, ventura:       "5b71de9d6f734637d500fb0d6426adab59b4ca9fad35359c494a4ee2f269a9c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b0777675c7175575a4da7ce49ecd1fcb012d8fef56fc6823e954a8e432ab2ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3120a728c77b3bde4cc8757f23ab1f3e59bde04152b116f91d62e15612e7ca12"
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
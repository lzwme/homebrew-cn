class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "0ea869450f516558a8ae905af9270505503621b3cb1071bba8d24c2b8056b1d7"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05669f6babf737fb2ccfaa6925fd2787ff24a899691a98d69c41412adc08f4b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab87f55ffeb2bc4fd9722973f7331faedb99316ce462f14fa71e5a6acabab48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be40089497fedbfb59436c391fe0ebffd04121e8309f7984bad837c1e43875f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbe9758b4c4f411c487460c1055022f8e439b9babc105c09451bf6d7d0a6a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fcd19bf0237beda8a7a219c814673bef90dc0e213f4efd0e17b2e181b01d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81688ae62fce6a56b13633acc3f1d71779ec9ac85c66efe5773302406cba35f"
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
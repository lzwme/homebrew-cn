class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "73053d6ad3e49e95316ccf866ac43ce2656177bbc01ed9ee56d7176916116cf4"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e54d1cc32557af2b6201c9566c78055e0998ec010a0dd7850c57799797dd34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff65b40ff78cde089c6b62d5f143504f8d7660a90d2442c7d0887e7de6358055"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6830f8583513405a5b2fea760d221992155576c9330264d9c21f036a07743652"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b5171b9fad01e839d67311237c8f755fabf70d527d7be7d7a786ccb6ec3728"
    sha256 cellar: :any_skip_relocation, ventura:       "f353ae6d40be1879a6cff587ac7fa8dd6c5b6444d705a0704f2ee2c3aeceef43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "870c48585a88d4725f23cf62375f20d02982d5475bc899f84bd5806e16948726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c219c7a2d5c04f448764a05b6f6294f037f2682d2f6a9e83bd455cc45bc29d8"
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
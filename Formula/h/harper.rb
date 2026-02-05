class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "4182e50001c66077bb16ce9fe93752382256ee2bd4b8d8487053a980b0a69269"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8063ab927977f666ee64d22c498afc4cafb26ffd07b9131a5fcf4cf089a086b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661c78abd8b2d50a5e355a11e918324a1fd75786ed2b8cabb2ddc4ecc0f7a38e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e29b906acfbc3ab7e57253ddde1f38a64979c4e9f55de506093308d2077d23b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40c91199faa8882ffb876a11108633e42a000de039655256ceca8265cd623ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2dc1e054e8de9565db6aa8d1bbc8c7a44604f65e9d72b81052ec91159b61417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5eb2b5f2825ec6ddacc42d61bd42c87a5ad5ff5cfbaa721441c3351e79bc486"
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
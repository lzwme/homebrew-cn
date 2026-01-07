class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "2f0eda17d0daf357bc911244369b387ac0bf55e6430a1b55269b58212ddea01f"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7275fb37dca4b20b564ae33fc8323c4aa062ed7c666b44db35a1bc3d222cf387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784b38d094cb15c00f5a4825d6f2c8f304f66f11949d1a0eee085ea126b65fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d312d523eef7ccb90df570a4c919b0ef9b414641b852cd99613c64f619923a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd902d227b343e50bcc609435e149a6c35b18c7747f64179346c518dd38284d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "672acfab00a453fcc95d1a501056cc77bab75cffe00f3fc80e50ccc3cc88e8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2768ad8c977baa82ccf8f97b01ab147b8cc09b191be77587e9e4f2e422305ee5"
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
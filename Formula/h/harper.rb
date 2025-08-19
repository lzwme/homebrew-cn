class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "4611b9d16301aae5eabf8411657ecee78288ff46801dfd0d4a0069173f0e763a"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd82092b1b972118a7b1895bbf3b718ce4ea30f0a68e4a45c341572c472bf66e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57395a098fe3c3dc0c05829cb1a791e20eaa85c80d6e49ee25340fd6f345126f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c6073e6fd0eda75760f5262857a49a44a940892cc2c520242fc29378764bd91"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6c5a5ecc2e2cb2277a939f0f2acc689e0cd16028f48405515cd59cd9cf12ad8"
    sha256 cellar: :any_skip_relocation, ventura:       "be47ff1175d7eb6c0a09ab12e20dc3d0dda06b4347c4cb9c20b4b7c263275574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceea6404f245caaf9821a6fe526f2e6fc0c9ad804d5fcde0ce593bf1338762f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf07ab02a174f7c5dc3e925982b7dcd77b1c8210a69c1fbb0a248ff05a03fb7"
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
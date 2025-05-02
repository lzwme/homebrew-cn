class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.32.1.tar.gz"
  sha256 "ef2836ffa1de6442f7050d6c1e249dea0195b79e246b2d6a228e7a673d15be19"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d82f2386bae9d747aba87a5690cad64c97b5d5811927bd0826279b806e9e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b56c1b6cf18eb90361b017565e960232838d277373e3931ced5c627275ff03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a8d4c782af34aae1bd73a020f7f1eb46d39dfdf06cc01c93d956c7e424332a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cefc53bc2840c34cc9f463713afa59a93f23d68008c156a27822d577f71bfa8a"
    sha256 cellar: :any_skip_relocation, ventura:       "a86147fcaff0be4b395897f43fbea750fef0688250f0503e0544d008f6c5d3b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026dcd90368a030e46181755d71d3a1e44d932136328b899211284bc2715b321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2cc469b06e5623c9531461f569ecc2a34655d70c480d3f66a9053ffdc113026"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https:github.comAutomatticharperblob833b212e8665567fa2912e6c07d7c83d394dd449harper-coresrcword_metadata.rs#L357-L362
    system bin"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}harper-cli words")

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
    output = pipe_output("#{bin}harper-ls --stdio 2>&1", input)
    assert_match(^Content-Length: \d+i, output)
  end
end
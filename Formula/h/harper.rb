class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.23.0.tar.gz"
  sha256 "6990e83036d77d3c854a2a5551836e7413cddddf5ea18f08aa4a074e88f2f0b0"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18fb5f6c852425e0c1e6e3628eaaffde2fe4d4d9d003be8e03934bc3712809e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c834e0a96e74f648c7aba25d7e2a5f6f5b1abd42abc0c8b9118f5a242d9e7533"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07b9cada127fef2b1429b02e127670f5982da05c7430ff76c656638a82a0013a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3fb00533a7030a09cf016f5b0ab70f2f86458bf0052a53afffddeb5c997d7d5"
    sha256 cellar: :any_skip_relocation, ventura:       "d376c697bbfbe8ba51ff4c41823f6d4aee80a0b3d2fcb90920b9213ffaf81604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca55ac6a38702fd191b098c442d9c94a88add6b71b27525b4b821746ba8542d3"
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

    system bin"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}harper-cli words")
    assert_equal "\"B\"", output.lines.first.chomp

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
class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.18.0.tar.gz"
  sha256 "c1ab7cd5abb98df442c37e5e8ccda5bdf8ec7b7960f6fadd8c4984f46476b591"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fab5597611b10b7bbc9af9772a7e0f4725425899fc087b2f1d921255ae80dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba3bdcb9da39314b5bd18ed5e9e5e0b559ff3d7e19ee7bb96b1e44c4a2c4301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "576f7c02b75c46484714462afbec2791c77a13f285dbd9e8c2d5200bca097954"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4cda8be119c83af13e5ba8af17ad0d55dc53bdf0ec49b6dd53c6b0521678f9"
    sha256 cellar: :any_skip_relocation, ventura:       "e876891566fcac57f1e18355a09d56d6d6c8709a67942e03f74725aa4bbebe97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a52606e6126fe5f32ce2a3666c1b8cb7962a6ce5272db956f266d634307ac3"
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
    assert_equal "B", output.lines.first.chomp

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
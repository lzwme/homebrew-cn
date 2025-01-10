class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.15.0.tar.gz"
  sha256 "b04655b10e45b82ba8a32f721b5077e6075c511f6b6f5d1279128ad86f016b1c"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f56715d841d5201bce5d0d1f524073ddc225db942c2560257a809d497f904a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119f04e51dcefa41d5fa66bcf55a8b2b754d2e0585bc79ff45a04728591bc90f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "389fc2c24b50e2cdecf0aeb1be96861fb20728deaca6233421bdf0e1950ea4ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18c374d2934e7ffbed67f4f92a1a67ded4848b717e258c9a83bd019eb57cd50"
    sha256 cellar: :any_skip_relocation, ventura:       "3817496fb2d8b9f501af754afabc3a359fd2d2dc24ff3066775f0c4111194d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0189b2dabdadd727e5f68bb5bc0f8e30dabb224d2b4c4bfb1a550cd655013c9"
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
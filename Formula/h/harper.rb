class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.21.1.tar.gz"
  sha256 "bd029e3b1c26dd8480041908deb9e4b9d4f1c511c1a8b1d8aae32ebd1e7e0377"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0394d7571095ce093ef48cb4264f7b8951c63c3831f1664e49aea8f64278544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0594a38d5fbdf47b549d901e8ae7b7b67fe86b3cc7bd686da04503021e0344b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "568775f6b9c44fd1091f5f4d59b8114b47ab4243b670bf6b206bf83a303158f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "181f40ae5ddbb553b0b9e8f70df5f4b2b7686fc106cc331072b0ea03ee81625b"
    sha256 cellar: :any_skip_relocation, ventura:       "bbb1bc62a24d0d49bc21115d91ed1bcd3e61a2c520f8c282fa33231dca0b2624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4862e945bea9d71fdcf999960a2ee478d0cbcb656c1c4598403e31e88e8e0845"
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
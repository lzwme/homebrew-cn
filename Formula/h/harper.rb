class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.17.0.tar.gz"
  sha256 "8680ff2477faf51324dadf8247dc731cf75ed0c350ec458a0df3473ab107fbf3"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7faf793968dfba04f59e1258ebff579628f3db180fdc7a1a4318579580226651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079fe5b5e358c4bc2e953d97ad1c1f79f44394fa71b21a13baa3f0e372d99265"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a719047258cddb73feadf6eeb02c17e190cbe1bc3b08637bdff7d9913ec7ed85"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4987d5aee2ee0782d243f8ad2cb34f2357be161662ed95dc7d23bf44b74801"
    sha256 cellar: :any_skip_relocation, ventura:       "1dceaaf0bbc1f21f51be6e9ac74340fec55354f94b9972950b16262c1dd2bf69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3b0918953b2c1ef1cce381b48a2b93b51d2849bde2f08ac230c2bc5ed39e00"
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
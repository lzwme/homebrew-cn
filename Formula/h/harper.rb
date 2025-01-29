class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.18.1.tar.gz"
  sha256 "a8fa46106a3915d513ea24bbdd40ee4cc6d5aaff1f0e85f5b138c1ee20bedd77"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f79e8d8b1866ff1d3f0aa790bd718bce9061e4dfb2c56fcd17c4832fcca55f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec6dd29f67a1178a4ea02af7b46a988441e0e44b5a3176d6226d73451ddf722f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4da0e786bdf25d00a1cfc416147bd072af6b6022fc1413591abdbe0c5ebfd4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "26309e1cc43787d1eea40234a616611babde22bed651487fae29acdd3bd6aa50"
    sha256 cellar: :any_skip_relocation, ventura:       "934d027fac9473c5a408ebcba333cfae3b4cf976527e7b20d0f8fd6bb18dafd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb62b27b7a2adfd9c7fb7cbb74a0baf29a0e53b5effe540ba1b99b2768c4b721"
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
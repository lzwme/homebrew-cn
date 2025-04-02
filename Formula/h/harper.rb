class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.27.0.tar.gz"
  sha256 "fb712c4499c42e39a2dc8e15e4a6e3908f647f0350c8123046f630000c282ae1"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9701bb04b46023cecc1392ee324050beedcb21ff272ac91ce8d6188a914865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6678ff19d857bb63fa25613e616b6d597d09babe7337ad38735d956b83338401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1066bb6352c419d0d2d60cdbaa6afe37ed14e09f85a986971ba52062a0fc8003"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c17c051a7bc182bb5bbf3c3c6d8908a370e0346368e6f3fc1e9eb1ac63d921a"
    sha256 cellar: :any_skip_relocation, ventura:       "815ee43b6c2e0984039f24fab6d5b4fa30077baeb938d81c2eb3f068814111b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc513649cab297184a8ec9bd5f2e5e6506cba11e29806c866e44a22286dc7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d1acc82f5d9ea6d0be8d5344b9448f566d65d52eed4084681b979073f39a1f"
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
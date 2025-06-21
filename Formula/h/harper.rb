class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.44.0.tar.gz"
  sha256 "bb5bb86ded921a63629d3db2731282fe1cdfc755bdb6c88a9e6d006970bbdf84"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eab410f82e9ff7104e401f4b8763ea9676e760bbe7b992615327a1f136ef7af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf2a2253bdb055167ded8c16a7eb21164ef316b579bab54b6a720048c996c12d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "299abc7bc2b80cf9667faf554e7d51bf78b8e66f42cd0cc59ece5af61b001da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f92267056856a07a415fd02b8e3eff2cc8a9ecd215b89a11f50ec45d74702ca3"
    sha256 cellar: :any_skip_relocation, ventura:       "50065c0f5f8cb69ed3ab8bb1eb40c3f10e5ddd4a7aa2b584a9b9dd16403ed978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24fee91372512fba6b7f5055051a982e4c3cf6a48fd0007d989c7852213e4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf0a7819312122cb8a9d42b5140cbf3f427307b0b6e04ae75bb98618e88c6f7"
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
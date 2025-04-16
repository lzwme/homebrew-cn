class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.29.0.tar.gz"
  sha256 "67da43c7d65a73248ed4b5108fb8e7467289ab15de78850961c639253aa336e0"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840f7851425d74cbbb24f2836363d06ebb4537a27ddac3b6bdbe4b187cabf749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20df33066a686d830c43f9d9143858f5333113d3b48fbb2df0d86cea1a9d235d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a89bf9f23e8ac9bbc6caeb0b447ca156e784ef884efebf66f4057b72f0734f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15399b07370c4f06e430778ca53008280a0917b4a40083c1a73dd9d5cf90c4c"
    sha256 cellar: :any_skip_relocation, ventura:       "32d8899cc4d65b779b55ef87ee80792ea09ac96cdd50dcadeac7fb038cb975ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b2455075d356163c18fb0276563921f81999b6ed663104deadc4c280bdd923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5102ad03a6eb7629b23fe18c5e3dd66bb9bb1c5ea7a242542f6629ac50ed0910"
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
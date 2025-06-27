class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.45.0.tar.gz"
  sha256 "9b5a1e0172083363c1c489ac469a15aaf8040237e4d92477264efd83b448bfbc"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827295e282f9794fbf7f3c13d16e0ee593f2cfbe14c930c6a0bc36f9ed6724e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd214e446310ae145d75681ba5b1bdf691a8d7ef8238bf3b1649d3c412deba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "663224b1bd1c4bee0b8cc83f8e8235851c62931e9cb33e4c835f441d7354da3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "06522407727c98f4f1fb7d8b2dfe838d633a3320339ca9277fdec546e29a3041"
    sha256 cellar: :any_skip_relocation, ventura:       "e989522fd938935546355dcb1c5540004d6be19020fcbb6c6b2bc3a077340dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe9a6636d4c677297e3c072b919342e89cddf0878eca3983ef99ddf4e82bc2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a53f5d31cb76ae3803eafec70c123f1282de8ec7c4c222955132cd871fae28"
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
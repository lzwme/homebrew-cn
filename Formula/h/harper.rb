class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.26.0.tar.gz"
  sha256 "fb003fb7343d96243ccf2b7703c61122e8543343ad99f3b935b467be4e85bcd2"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef37fedad9b9e32e193a604d8e1d95c7576e3510bab8ef4bc22afa700c530b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a3135582f1334e19e79ba4f5609b36ea6af6a3968ebcf7b2d549400c8303c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36791a1ca5198e1615261230c3b40db5888dabb5e8817f061ba8ce92b43f32d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "501e1a1c1f68be011138baea2dd44b8d3fad82a8c1002760227075d43a5fc836"
    sha256 cellar: :any_skip_relocation, ventura:       "8ab7ee70a2908a2955c3ffa01a5c696258aefb0839e0a566077459b17bf4585e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0827e8821769d2ee4fb98cd183d43d881e8ab73709ebf67e6ac8462d89bf6912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954299a4172a9c95a82f49bd9dbf2cc3d0914a7cfa0f5ce8d1ab2fbfc9d93ad6"
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
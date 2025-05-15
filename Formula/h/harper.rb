class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.35.0.tar.gz"
  sha256 "0d3ab41a46848be51522aab13a5b220b692af24b05ee68abe630be3123cf803d"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb55c76fef9b0802142e649ad64d6cec36da1fb5fe7db8d8fc435126a7b95c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8796a28516e263ee729c0d45ec3922630a472117630a63624afa5332574558e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d23a74fa07046627b2c959600ef314f4b1c0941bcc7631d04ba70c64f08c58c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "95799365fa6de642842c21a61a3e57256303424414f67b3e704f965ea524788d"
    sha256 cellar: :any_skip_relocation, ventura:       "196fb6b773766ee02b87b241004f5fa46f73b6d25e2789820d6650ce8c4bdf6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7baebe6b33bde83c63a9d17753d84c495ba4784c482fb5280276082ce7dbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "066671a7350f08cf71fa85728db1c55df5c9614129eb0a6fe5802bacbc8c083f"
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
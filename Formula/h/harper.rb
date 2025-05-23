class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.38.0.tar.gz"
  sha256 "78f43f3f9c003070ddb34c64ba419711030a172de44b9fff7ab4dd13d04e6ce5"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fb01c4f054be446d695400fee6e10adee7352c3db9c57c433260dfc69aeca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957a72ed4add85fc817401b05d3b9a8196649ea085954ff6253335921952864a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f32e535b52f11ea6aac7ad623ec4e0a666d13bb580b04f4e3997d0b572740bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e1ae90590f4ae3bbb5d3daf9ce9df7d5d16946b5f54da1dc04d9f78251591d"
    sha256 cellar: :any_skip_relocation, ventura:       "6092948c00dd01661fefc5cc799f66a781f3e64fc29c13da68a2fc7b6b1a0179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a95b609ced04eb66f2dc8bed858a5866322c0c06e701175fbb06dc9876e9cca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7fc93270c3ddb7c6d4b9d16bf2b0399601000a8e459b38f4bbfb0c25c4662b3"
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
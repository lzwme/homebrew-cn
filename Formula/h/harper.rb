class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "87775a1cd2df07c49af81c4a12e30441c342b4abdb71d3c98fa380181864f08e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "598cf68d6f133c7f71f8404cf70d4a5dc078f4cc7156cc47e4c16022ca137c2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97605876195ea52617b643ddf5ee4768fd112dbcfba2cb9df49df92e4666b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d508bd2e667d64642b376b706e4eef096ec02d717b0ca00269d29fc598bc1bab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fd83d4b3c826c88a039e3c2f0210b8ede40d36818461f718e014ba1184290b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64f130d07807d0e5a509c4215f599f7a24ec6eb209a4ef8feffd0c4782c1922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b60e5054dcb965bec1e1361e2cc2a143144c694e9dcb489913004a81299f29cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    system bin/"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

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
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
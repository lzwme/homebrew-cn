class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.47.0.tar.gz"
  sha256 "ff07e01a838e335aa0b72da0d36942e1fe319624df401ae7550fbb40bcc0726c"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866eb5f7c4b0e650ccc228c032c595ea8c8a33ec44fd57f61b18449005128271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db4ac2a133fff21498a3e5dc07bda97fb29089b33dd74968e55d6e14b73fbdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73426a40cda27f14ad817fe56eac23ab754e206ffa5f8f1b3b5bf19f44a81a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea0f291d79f9a65fddba80e6fd13f8a72c8d4317ad647c6a0a2a7d82a8bec20"
    sha256 cellar: :any_skip_relocation, ventura:       "1999fbce8c701faa5c340f5da88702d79fcdb260211302cd246ddc463de30c9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "effebec2f8c17574680b02dea595371a91daae8b63e90dc095531be904704f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c1273318374bf0f14a559716a38068bb07ef0e73abe8875fd6dd278ca42d39"
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
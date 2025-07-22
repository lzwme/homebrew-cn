class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "125dd08ce276a3c6b797a431a5abf158a23fd353d4bc7a50e450bba1db32c087"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aa31743c5b5b435f2bbb8787af7f3dc9bfa85686dbcd4ae8885488848b9533b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80ca57bd4bfefc5b36bbc93b0814a506fcae0cd3e1bfaddb190f2d83522ebc88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf577b23a0fe2365b1f8a1a260d27b5b125f157f942952434449365bb0744ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "30753eb23500d4fe33e151dd86db9b31edfca601bcfe582ef37750245ac1ab21"
    sha256 cellar: :any_skip_relocation, ventura:       "307af01da2999502c2279db6f63797f6509e8bde6c68ed2e0023dd68200ce7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33930b23ed39b66c42b04f7064cc6c6176a29294e72b34c350ba2d4877ea897c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3f8337645476463a4e4f8bba4963d4bd19d98e3e1555580f8272b2d4b1a51f"
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
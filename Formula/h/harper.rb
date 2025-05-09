class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.34.1.tar.gz"
  sha256 "bfc20385a67a1094221d2c34dd6895f9517e5037b814cc8749771d04be51f68e"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077aea987a8db3b6457f585840bbc3f6aefcf6b553290bca38f87523da0980c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d99eeaf1eadd98a7d7ce97cbd4aff879503f1fc8bfff4d25e451c6ff623d585"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6a416759eb35bb386268272f6a2c0a83d76e49cf5463b5018862b3ff1c76236"
    sha256 cellar: :any_skip_relocation, sonoma:        "69457cc27245fbdfa15d9f12c7bc7796f8dcff1270b041cb55035e6dc6c1eb48"
    sha256 cellar: :any_skip_relocation, ventura:       "39016ee7ddb7fc163e6958787b8142c52cef807b658fda51675cbd7c10d202e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff19faa932484d7b2c677a44c716104d77b56d5d6b35f75ba836227d46036cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6805e7c999e72f6cf4147784f14967662a2532dcb8b3b263516163a2de28294a"
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
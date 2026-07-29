class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "7d74a92b61c88e708c52869c9ed398667040d2ca6d46070aab95a6b4fa04476d"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88df901eb76129b1f7413a943bf0e832b291fd5a187cf49382a358bd9ea60602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6c8b9ddb13d9b02fd2ff06c6e565d4713e645d11b564a4a997a829f4673b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce05e2d8b069ca58789941334f60319a19f70a5c02b53d9851be95e8cb37eca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "deceb235d096ac4960e931e666933801620a553766f9ff64e9297298d3465815"
    sha256 cellar: :any,                 arm64_linux:   "6201c0840ce57b58bfe5628db5bd6a3830ed60659997a2ba1c2a0fcbdb1794f5"
    sha256 cellar: :any,                 x86_64_linux:  "2d90bdc44c83a8ab5790468abd71d5fe6ccc3c6a77189a8bda8103ef80d8dece"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1")
    assert_match "test.md: No lints found", lint_output

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

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
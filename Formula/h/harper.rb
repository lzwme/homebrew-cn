class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "53734cdf3c8b88ef625ecff2ae7bde36b57560b2aa7c591fcd190c9bbd59c991"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "802dd5a11c9109a460f3ee67bfcbeb9c074534434b5fae863701bd96b8c9eb51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78754630728e587c95469828d84f95d4f157d16380bd4e94c42b1a82c39f05ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e4dd4b70784404e9264c0837797ed8972ba798ae0d8a8719117b9df180de90"
    sha256 cellar: :any_skip_relocation, sonoma:        "8acc3b5296e6aeea4343e52458ad4675db40994aceed8e9bb19f9e7337e9834c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5faf21efb8b0bc421890736a40f5dc9445d03bdb7cf9705c7c83bcadff8d0582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bc11b74dbdc4db788a8d43c4c486b6e2865dded9c73939274f350b9f78de40"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1", 1)
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
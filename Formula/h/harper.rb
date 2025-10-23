class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "f8f543437111a5c5c54c3e86bc58104ee92d31c2ed46d44cfd73da9b4590d4d5"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d7c92b61bbbfb18a23dcb2cce4c3656408e1bc9cace4a384b17d362137f94f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb183c0a3836af98d609717d2a8c9358ce552a2da1904f45b2b5ca9e8725213a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d844a1396bf29c50ebd178812cb0ce79e5fe0d7eb3c94d0a70741f6672070d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "a49240660408e6ae716d1333dce9b8dc5a3489d974bf19632e00266568539ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14c202204a3b8c67523548aebdaec71004d783c00397f8a0bb3ff5800d03f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2baccf06649cbc68c625a238f8be4b2203e9c62bf3c0eeb2059761f330a648"
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
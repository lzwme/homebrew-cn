class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "63bc2153874a8d98f76e7c92af66bd97da97f089461ec4e14cb7dbf487c7ca07"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f1f8ee4985ab66aa2fe87854213c2b7e396131f6d17b3363cb86f85b621dfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab732e929dea1ce05daf548744c68ae1c6f3b23e98bda832ccfca02c0e584776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84543d301c60b080aca6474a3e0d5402e48f613bec317412a72e6b5ba9cbfaaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8011589bc068e875c9423672bce6696103d00f679d443870abf5e0352ee05570"
    sha256 cellar: :any,                 arm64_linux:   "07fb94f08ad13ffcc194e598d11d6f7632bbc6c8fc85e4b86d8a56df99e0b248"
    sha256 cellar: :any,                 x86_64_linux:  "74a1e4fd9c1d009e0633173b67e54963b260592e7c6309833b0606e51ba079b2"
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
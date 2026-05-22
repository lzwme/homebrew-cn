class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "25f521bac7ee0aa260948d2b0de356cc55d731ad38f54a8f433f380e79bbeae4"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f4044b4163a1b6e904cf51e7e1d6a4144f93b7a5bd20605e8cc21bb831b03da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f485a0545a769d2e4153d7828de0bea844018aac3836aeabee70ea7db9c6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de85f39d03ac1c3eddd3e694bb0fdd2a2543845ab91988444ca20e8beb953232"
    sha256 cellar: :any_skip_relocation, sonoma:        "a242e23a2a5f2990ca0d39280ce06ea6c6bab7c665e64d250448a5ee1e820af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a14f1a5e7a61ddbe68e16145275a065ec164c3771c967c50b1b9d330418bbdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27f52494c95039a0102852767aa119aa53ead4556806d2391d166ec8cc256b9"
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
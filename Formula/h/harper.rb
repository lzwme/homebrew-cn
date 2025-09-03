class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "9b003620c37d7dacdc26a6cbaf83ad4ab31034446a997b331acd0441f94a1336"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39cd28cac9999e4ddd6511dcfb476523c2d68c6a236bb043a82c0a00ce93c1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7c2808ec437680d4720de6f89db6a70cc40224c9f6dcdfca18b2d9dfb43db6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35c24f0e8755f0bf6d9d7ebd84281a08166f0f715e160a5cafcf61c63365cdc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d0c2aa13d7387c4818af59d0aedff40834da4b4b27ebaf27632e8d1eee2f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "9d431dabcac989b698e8652aa5fb165edb855f3b6213cf4438bf8647a46d7564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72b5613827d4411f882220b322180c517e4eb85340f425f7b99297007415d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a997f60eb4c6b31d26291754d8b6fcc6a9b6196272c0d546975a268344e09a5b"
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
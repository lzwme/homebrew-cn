class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.14.0.tar.gz"
  sha256 "af07f2a621b876cb77a4dfa376bdab0df2e1b0b210816bb26e73e56878367634"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148b0697862806b203e6c7858835277ab3033ec5c3c34e4d6a75b5d6e5d81676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e3409272625fc56ebe9b099569471e473438790ba84449e36389d5adfe0102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "801e9de612fd3326e608db9fb008a4662bf5395ad12e8cad0d2058720bae91d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "af584e7ecae36e366ce27c8b230071205e1238b010b6ec085979a2946e9bdcec"
    sha256 cellar: :any_skip_relocation, ventura:       "79b36d95793eb31bdc131811aea09e44a7b07e980486b3d13b815377b719edf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33e46db626a6ed286187fefd19e48285d972a82cfbdd5e4333ab5d7c6a2428f"
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

    system bin"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}harper-cli words")
    assert_equal "A", output.lines.first.chomp

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
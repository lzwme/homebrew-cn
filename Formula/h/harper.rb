class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:github.comelijah-potterharper"
  url "https:github.comelijah-potterharperarchiverefstagsv0.22.0.tar.gz"
  sha256 "148d8d202a11c716c39d1956b9dec6dd096685cf83732bd246d5821740233475"
  license "Apache-2.0"
  head "https:github.comelijah-potterharper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65eed4074cbfe952aabeaa6312b24d027cf3d92305f85d8dfde65873446bfec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c6ce480fb554a620aec9fb4a72559d999410c6081ed82fc6b81189ad104da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afa0ff120e548ba97bc2777e1de53ec04d5c3a04eb4107630b6c08a05fd90cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd3149ebb67a72d4afdcedf4154eb2a7d88598a35ea47fba5cff1f7e03608fe9"
    sha256 cellar: :any_skip_relocation, ventura:       "98606be990e7c9f33b649c65b74416f8767168661a288a5b6be140a8666b7cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259a22931c4e8c0d2355b15e2e73d8cb910cdfff86824f295f5d3a01841232cd"
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
    assert_equal "\"B\"", output.lines.first.chomp

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
class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.28.tar.gz"
  sha256 "cff4d4c5228c1ebb8700b0f26422fa7270f2cd73272de828f45e388e1201fc29"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e87e66d88d79005c720719cfb1dd0c1bfc0e9f6406c206deed319ae1989c98b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1dd932043aab5a783f00d4ca926b85919e88729c4a8bb86ccc5d3e9967ed719"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3c8c048a26936f27a9d46b7cd5ebb5baa6a130fe3d1f5c02f53437129841c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c6432a777ad6654ad43f7b1d92c0befe332403ec9c92a016bc3d9c4d5ee010"
    sha256 cellar: :any_skip_relocation, ventura:       "1b97518ad279de58a01769cece84c8278cdf6982c37484b6ffdb9747913ccbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6635c3bd493c5824b23149c96266d4b92b545928d4b291283f682bc574baee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestinymist")
  end

  test do
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
    output = IO.popen(bin"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(^Content-Length: \d+i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
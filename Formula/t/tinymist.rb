class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.20.tar.gz"
  sha256 "5af73d3793d2c243f4e758951c5c62e39b539ba3a9ebe4b1af2d712de99e8f03"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d2c287264c8ce3db01c91c522cfcce083ac36acd4772ea8f200d5a0259f54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5942fbef03fff94c9d194756f2e0f6a7ad039b2d1993d79d7eefce69eb9c5e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcf65c113d04fa89fb23f0df4a3116ce65d25ef0733921ecbe9936ac3485d93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ce4c536fd715ce6b722e9931f35e2018433196c9ea7b6526d3eb5e99e4bbc1"
    sha256 cellar: :any_skip_relocation, ventura:       "67201af3ddf99b7bb6860627c65fc39b557172f2b341c13a7cb86549991b4cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d43ac4fa5866f6b68b45ce8146a0c28d0595ce05c852afd4f5ba8b60574737"
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
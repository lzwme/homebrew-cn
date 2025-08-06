class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.20.tar.gz"
  sha256 "164dfeb3495f4ccc5c99e5db6003b5f1c7a1561e40ad9ad0abed258e7e478ff4"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1c432baf4673b12e96ac33fc5cd951a9737bd8406b31911ccd4b4c30bc90f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44067775ab7d338276a13362289939c7e780517a387b0503335a6cd2087801c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d77108f2e14aa955eee854cf2a0135c1827114b582694889abfcbb14b66bdbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a5f201a3d78e45ca4ef0889e99dc2f193927d0435f32b90154cbfe2d2ee916c"
    sha256 cellar: :any_skip_relocation, ventura:       "5e45931ce1fb5ffca54d780a7ab45c1fd273f236b6ae61e166aa84d37be815e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fce61814cbbb57034db7df1077563836d434834130af983b90c80a3b0d6f0bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16857e1778ae7b0c457a7e4040cd5cc5f8ede1a1bfe3660abe33d45cdff605f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
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
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
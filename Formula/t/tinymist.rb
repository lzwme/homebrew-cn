class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://ghfast.top/https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.22.tar.gz"
  sha256 "810d570ca1da24cf3eb4410d143211483a24b9d914214a8794658da7d697810b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc04ad347d743241b8f2a5b76aa7f3246c0c1a431080bdf3947ffc614a71492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315f81ce7262281e4b30ca672af931b5976f00d93fe789cb15e9230b01b7e37b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf82683425fca899af3a2119b27df2f0f75f95c359706f6c7f5b7a7a94966a26"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ebd67f561a2a2ec7238de0e0388fb94a427419301672c2e6c13641ec53880c1"
    sha256 cellar: :any_skip_relocation, ventura:       "e5765b347e71d933f14fa6ac17eb78e937de706c91d109c4b53a98f5137e5f41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df39b193f19fc6426bad55bd8405d6124dfe4d5598e71fe150c9c71ab4abf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e06542c5eb9b2c5ee6043c6a5609b386f7bf9dffbca7b2d134ff1628976ebb7"
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
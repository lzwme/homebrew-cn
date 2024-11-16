class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.2.tar.gz"
  sha256 "f51531ff4ffee1dbeb6dbadf9db45312a81eb1177f886ac9df01766a65fe4ddb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d5f81c2055d3c55d93fe88134d8fcdb13297aebadcba6f68d87ce3202831f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b204c15d6f120c7445d2a185b6fa8db2ca8948ecebcb0c625d95e60e53d47a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8021582c7faba5cf239fe588c9e2d30302f9dc178a415bd0b775a6a900c45a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "62090b299af3f5507d766d5ea8d62fbc081acd45c3f7650278062a2b1d90c7a7"
    sha256 cellar: :any_skip_relocation, ventura:       "c50d4bf9da9ef387b6ba960976ff07b934e6adc7cf682604446f00119be12550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2f120cf8789480a1e3eda9d57e6f6ac19aa2b52a375d9b262d28b1aea9b76f"
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
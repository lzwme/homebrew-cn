class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.12.4.tar.gz"
  sha256 "2986bd1c524b43a1839d754966fda2659ccf3f26f96573e040b5896405c1835d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d4068624d3cbcdb112e6b33b47013b4accdde36756bc55c73571f92eb18c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f8bc614b6bf5ac08a48df57dc640850012c1ae41954c9bd89bdc64f5c4bd67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1af17ddd310495bf6096439ea7e49a703da5fca494fd2d28dbe36072d8bbc36"
    sha256 cellar: :any_skip_relocation, sonoma:        "3355b85389155fbb1811824fef5c618f400c81c6853d19ad7848fdd6356fad7e"
    sha256 cellar: :any_skip_relocation, ventura:       "42c9f3c6c30d063e526e479a6f4b9d30c44b2e43c33acc5dedb6e332b5954e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21baa6247af206353ebea1067ec2bc792d1d0cbab1fc6e1261f08f2b810c8dbc"
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
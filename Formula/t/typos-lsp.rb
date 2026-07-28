class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.54.tar.gz"
  sha256 "adabdcba93f884cf100cbfeeaa4aa47548dc6e6b58e9978d947abdbadda2762d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5efeffdbfc631d97fb133bf80e24197350c99efef16b69ecaa9838cd850f260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90333f3b92ad954ec67feaa9304abed26ed74ee0cd4104a406271ae86be732a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51217974f79665828b2f719b83bdae50a81f582629547e92e32e0dee76a0f953"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4eaf28916aa828bc7da9f21fd30b6e5bf77a12caf48b32a5edd21bce1be51a6"
    sha256 cellar: :any,                 arm64_linux:   "f4ded867e441377414e9931c3cffa0ce20e98bf480f6036924cf0754e210b066"
    sha256 cellar: :any,                 x86_64_linux:  "a8ed8c2c9498ab1f0aec0cb9a582c90d6f7a0a3b88b1298f012875130a508774"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
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
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
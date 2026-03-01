class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "41fea7ae488179ce7303d8496683950934e3f684ec5b35bb7af19d3e4e2446be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9e750fec56bcaa2e1b3a3a8ae9da95d8d8bb9879a591f8d3a61dd83425b5dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04da618e1da52fa29929a38dfc2f45180346f7b0235625f12108fed08fcd3e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d61366fa2ba60b68cc78ce54b924a5ceb8ba22ec092bc6cf7b6814e3384889"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b52ee3f71ee4153df7226972162d5944394761f7e657a15b2ff1b216ed82fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e1f39466b9079e901a470e117d899aecd22f34c7d00f2ecbdea9941e2323371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ab64b2fc8f6d0ad7bc5f9ae8fbc09d716a996b13f452b28806576b0e976b24"
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
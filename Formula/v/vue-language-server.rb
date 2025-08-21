class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.6.tgz"
  sha256 "ebe9cdef3444805c84821aa4bd009a754051e6c3d95e8a591cbffa1c8649045b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ca218a9ffa2153a3debdb3f8f8f57afe34621f0fd4b636d66ff81431d9a0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be3093b8f5721cd2170932b177d510add8f9f3b5bc502680caaa613bcd20106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5de99d831e977327a71c6bf384f4428876695b260338a124584c248e53d0009b"
    sha256 cellar: :any_skip_relocation, sonoma:        "227fdea9278d7618d89560bb599271a1ea34b2f42c2175eaacb5e0f30684b736"
    sha256 cellar: :any_skip_relocation, ventura:       "6471b5e4d0e3800b4978a39159e1e3bcfae06638c84d69dc5737d063a93c4bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2f0237bdcf95c58a56b63f3ec617e9b6acbe75db9e7e70d0660a190cdc0ea3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
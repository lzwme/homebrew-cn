class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.1.1.tgz"
  sha256 "f1c1f113bf199e6964852856e448b6d1899f00588f1115e4816d6e374390cc41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a28f76472d4d4c46a0c7bf5a15405fe0fb995515b929db4d0c8665cba31ad78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e55de26f14af1e61b0cf802dd4a04372f384f412aa62a13dde0c84f0cfb33f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27042c041e98f3934bcf4fac6bcc2d6cf66e2c1d99ed33696ed30761e97a1abc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d538779b59d88c2c2d38a6a83586e154837189919ba07c93dd2ffa499580dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140c22fc69cbf7c6271ffaa73d688dec3efc2ef522ca985621339d7c579c551b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540f3fe91d363c8ccabcf8b661506cf998cb0260ec9655635f296bfe5b937418"
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
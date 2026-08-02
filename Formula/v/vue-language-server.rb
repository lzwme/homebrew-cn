class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://deepwiki.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.3.9.tgz"
  sha256 "70ee3b932ef2c4643e0e420ff1b59624f3ba59e8827b2da07e8b85802ff9a006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0db502cef5c178d79a10ebf9d2a0c351500c5a27eb6a481dbdb19ebc78f3775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0db502cef5c178d79a10ebf9d2a0c351500c5a27eb6a481dbdb19ebc78f3775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0db502cef5c178d79a10ebf9d2a0c351500c5a27eb6a481dbdb19ebc78f3775"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ca8afb3604ff23ee993acccdddda240013333adb09f34b389234cb9662caff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd413867d0f8d67f4e097f7333ebd7ca73edf209455ca3e9998283bf7406d2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffee8a334ae9e8821b3cac60c3c9f04d8dad5a461a5462cdc922fbeb90a47206"
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
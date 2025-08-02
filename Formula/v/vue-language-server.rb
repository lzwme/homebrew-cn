class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.5.tgz"
  sha256 "954962ac29817f8a3e390ee3f7cfdb36d91b5dda048c359feec722530f0e0e75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c870b7d8ab3f5a2114c86851a08c6943d5122c6ca8b62600e4619745f8c6f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da3f6608a7af448ee266cdec8687c3a6da3b435fa5c05fd34fd3d5e756f872a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49c54f1ba1823dc4e701e41998b53008207dca9544476428f429c3ab09439cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dfe07d8314b112ac20404460e23be3f0acd3985501683fffd63759eb1d464d0"
    sha256 cellar: :any_skip_relocation, ventura:       "8e16b0cc78a1c2b684fd5e09d534e4477d2ee3d09a41f3ccc59cc371e99e4477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a72a30ad909b7b1eacc0f1ef7cbbf07e66899b432d4080b18d56a077107b8a8"
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
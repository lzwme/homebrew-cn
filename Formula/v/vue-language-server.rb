class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.1.3.tgz"
  sha256 "7eb9c6a9360875757dc3f4b94be304e11a44627dd2cecbe947a0f8308064821e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa68f76ce9c6bfee24fd64b89fcce3f9dfdb6788a1930f5e5574d578d982f02c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1deba4bc5f23b4d91fcf182371589c609f51eb8fd75816d65b9030aca59869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0c559d5c98edf408894aa05084a221683061b91909bd02da0756027ee2d0df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff73b82c0b4466cc1c40b3fd8546db9748fdf827fa597779db02c9d31fccfd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d717ee1879dfbe697baee20a5a46d9107663c148bd396dc6f34d3a7f8423330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19174c114c6fb1d80e2d7835d275375effc8e1b3df0ef487a167aeb187158611"
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
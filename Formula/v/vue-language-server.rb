class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.2.tgz"
  sha256 "d1726ebc809980e71dfe586fbfbe5d908c282b8ebccbdafe976c53659fd26963"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846bacbbecacd866e1746933138c379705f7b5592a5ec688916f6274666d36c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f31d27e85ea211122e2e9d9a8c1615a015a771c585311eb36f6f7950abded47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc7e56351a2be331532d3802a79d4f800b75acdca6b3f89240d9a8abee758759"
    sha256 cellar: :any_skip_relocation, sonoma:        "188a1af74c7eaca2ad5ec001c6b579c91eda3cdf4a0f36b2cda6cd6e5f137233"
    sha256 cellar: :any_skip_relocation, ventura:       "1437be89b47113f8e9eaa66864a9ccd61a9c83ed952166da2c7d1febb00e0bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f49ff4ed6cafcf182056d63d4acf68c510399c3efbc09338730ba8497f2ec3"
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
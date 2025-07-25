class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https://github.com/vuejs/language-tools"
  url "https://registry.npmjs.org/@vue/language-server/-/language-server-3.0.4.tgz"
  sha256 "c6a1820242a8f871a17827736bcd413064f04438e80284e9888064f7192d78e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8781dae70193947be3d0c06082f6ef5f33760a15711acf4975a43eb948b70054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d2850c7a92659412fb28a5a7e5418a3008784cb93000d78abf7600173817636"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fd156fc329bb58bc557bfb6ac2ccf5ec8b32d5ef17f44b54469813e453b4f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c6aa7e2263b98433a50bcc59808d3fcb0f75122e7500dead5178eb06a35fe6f"
    sha256 cellar: :any_skip_relocation, ventura:       "1dc8d788470810c809e180674f7d56936730e7e6fade4699e16b4c2cc2c3b2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b091b94f176feb6779dea44371158d23d8d4abfb05f93baf0de3c3284a89a18c"
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
class YamlLanguageServer < Formula
  desc "Language Server for Yaml Files"
  homepage "https:github.comredhat-developeryaml-language-server"
  url "https:registry.npmjs.orgyaml-language-server-yaml-language-server-1.16.0.tgz"
  sha256 "e20905ee0e309898e3327f2a1d4cd0bf942512a0a2c3b20d2ebbda3d5fadd4be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d51fde9fd6e0a135c8e77eb91c1e304b459050e5e07cb0dcd4800cf2c8af053"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
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

    Open3.popen3(bin"yaml-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
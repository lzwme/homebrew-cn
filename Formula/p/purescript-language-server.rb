class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https:github.comnwolversonpurescript-language-server"
  url "https:registry.npmjs.orgpurescript-language-server-purescript-language-server-0.18.0.tgz"
  sha256 "4814f287375c5b03ff71d11ab43e2eab7c87bb4d856d22db70cd45f9051ec327"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "79af5f956fc4d788f73bab6dcbd8c44bcb235e0f94f7ced418ca15df9b0e103d"
  end

  depends_on "node"
  depends_on "purescript"

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

    Open3.popen3(bin"purescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https:github.comnwolversonpurescript-language-server"
  url "https:registry.npmjs.orgpurescript-language-server-purescript-language-server-0.18.3.tgz"
  sha256 "e290576084f4984cde3a37a87e2ab3484a5964603d260544396db77018b8887a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c4693906fb4499e3937b39d88d4f696f26fff1d1a85557e495c7307acc6e42e"
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
require "languagenode"

class DockerfileLanguageServer < Formula
  desc "Language server for Dockerfiles powered by Node, TypeScript, and VSCode"
  homepage "https:github.comrcjsuendockerfile-language-server"
  url "https:registry.npmjs.orgdockerfile-language-server-nodejs-dockerfile-language-server-nodejs-0.13.0.tgz"
  sha256 "2e6a287dcf5de6be2a1c01f149a8c3717fa0bc8a689cc355d94198081779d067"
  license "MIT"
  head "https:github.comrcjsuendockerfile-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aabd17fbdaf0480be3a769abb74e4b48c97dc60742c38a7054d9e6336e9c97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aabd17fbdaf0480be3a769abb74e4b48c97dc60742c38a7054d9e6336e9c97a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aabd17fbdaf0480be3a769abb74e4b48c97dc60742c38a7054d9e6336e9c97a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a05541b349d4d4e2998f12f9b5683a3028635c0b1435d8faedf8674604923347"
    sha256 cellar: :any_skip_relocation, ventura:        "a05541b349d4d4e2998f12f9b5683a3028635c0b1435d8faedf8674604923347"
    sha256 cellar: :any_skip_relocation, monterey:       "a05541b349d4d4e2998f12f9b5683a3028635c0b1435d8faedf8674604923347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ea4c4c48e6f7eda7df3b66823d4b8c4a5ff2ec28e90a27a24edee1596a8392"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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

    Open3.popen3("#{bin}docker-langserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
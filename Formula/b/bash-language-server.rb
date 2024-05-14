require "languagenode"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https:github.combash-lspbash-language-server"
  url "https:registry.npmjs.orgbash-language-server-bash-language-server-5.3.1.tgz"
  sha256 "15bba3e57e679925822be90645dfb287f296e6c33c50520b5f995bf85e22df06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46aaf58c005141ed998c5b30effd00943097937e7fd6b7985845c4200857ad6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d193412747347fc43fd5005f3752706a23ea71097850d40ec4b970f2b091be7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28b7b05518c8901a610c02c544966c9704c111f36a87cf3771b36753448e46f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a5f3f04e88ade55556c3042df908eb499829f6aacf4c00368e2db2d37efa44e"
    sha256 cellar: :any_skip_relocation, ventura:        "83026495f48f5c8577173abc57401763c872bd3cf2822cb9674467604fe86eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "d4d2e2bff22d407040574f6b44487b0fbd0c5c9f74759f9c05b6e33ee25f05d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0a81ee5e21f791bed6e3bd24513e56a0e8c86526b7d0cf9bcc3ff4f1c156d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}bash-language-server start", input, 0)
    assert_match(^Content-Length: \d+i, output)
  end
end
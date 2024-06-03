require "languagenode"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https:github.combash-lspbash-language-server"
  url "https:registry.npmjs.orgbash-language-server-bash-language-server-5.3.4.tgz"
  sha256 "dc9adfbf30ccf3db011dfe9a9466d0d913942cea27e8a3063c00f0b89bf367d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, sonoma:         "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, ventura:        "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, monterey:       "18b9d5fcf1551db9857893a5a636ea39163e2efc62220b4878bfcc061d9e2027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bef9fda47b1debd8e6c833accf276278c65c88ce5d68fd406a9e25739da2c593"
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
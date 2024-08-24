class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https:github.combash-lspbash-language-server"
  url "https:registry.npmjs.orgbash-language-server-bash-language-server-5.4.0.tgz"
  sha256 "398971fee90b72014d72ca63b163e8f19d3c7db9528de8e43075c2ffa579b7b2"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "10c27a8921363f70f037d1400912de1ec9addef631a5cc1d3cab2ab45d684368"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
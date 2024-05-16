require "languagenode"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https:github.combash-lspbash-language-server"
  url "https:registry.npmjs.orgbash-language-server-bash-language-server-5.3.3.tgz"
  sha256 "a199ba7527574eb6f0c6adb0e15ec057f388b378d38c77fbc6f30afc92275c67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2ffc008f0f95a0efdb2f5f5e1580406e30af4a450f3fbda814991d78d100326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9949e6bcdcf9951ee51a6f878db3dfed44d3af74c3bcd9eb1c090693df17373"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b104dfeaef93a5bdd62a42759fbe44cf9bc48f300b78850ad7f47650611b523b"
    sha256 cellar: :any_skip_relocation, sonoma:         "69d69575ebb9ee49f8ff5a3275bb2bbc710757fa7d9ba4c7632bc38fc9da9c26"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2044c22effacf605a2f5e5f6652bc93e5aa8f05e8cd7cec3c025f0e9bb5484"
    sha256 cellar: :any_skip_relocation, monterey:       "53f2adf982c27f94304e5df3183dfd2e0ad0f251760cc50a5a0d764fdb657035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34a8b6eaea2b65683d9eca55ffc3ae87e8e06f128ff731a43ad26f6af756759a"
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
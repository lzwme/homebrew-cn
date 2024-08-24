class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.23.tgz"
  sha256 "ee81c05260e29343215d333b0a32f60c6bae2b4a4025e0f4466550a786f523ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e17590ca5ad2b1f132773e56dceed0f7e30bccf240f452c81f81f788aae18b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61e17590ca5ad2b1f132773e56dceed0f7e30bccf240f452c81f81f788aae18b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e17590ca5ad2b1f132773e56dceed0f7e30bccf240f452c81f81f788aae18b"
    sha256 cellar: :any_skip_relocation, sonoma:         "80179d46d6092738668c98f416626147d4733aee9210481645efd121aa81a77d"
    sha256 cellar: :any_skip_relocation, ventura:        "80179d46d6092738668c98f416626147d4733aee9210481645efd121aa81a77d"
    sha256 cellar: :any_skip_relocation, monterey:       "80179d46d6092738668c98f416626147d4733aee9210481645efd121aa81a77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b38c618c90a8a395bb8c5b767588e4f878b0db923a66b3b48a36c8b4544c80"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    (libexec"libnode_modules@tailwindcsslanguage-serverbin").glob("*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      if OS.mac? && f.universal?
        deuniversalize_machos f
      else
        rm f
      end
    end
    (libexec"libnode_modules@tailwindcsslanguage-serverbin").glob("*.musl-*.node").map(&:unlink) if OS.linux?
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

    Open3.popen3(bin"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
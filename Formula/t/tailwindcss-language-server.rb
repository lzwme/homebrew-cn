require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.17.tgz"
  sha256 "c542f965c3bebbb6569577609219c9a355d2b74b4f74ded1680ef6e204d38de5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "215cac8526e79ee13cca1d96df6f1dbfe49a4e5665889be3b8d6e32d5942b3c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215cac8526e79ee13cca1d96df6f1dbfe49a4e5665889be3b8d6e32d5942b3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215cac8526e79ee13cca1d96df6f1dbfe49a4e5665889be3b8d6e32d5942b3c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "22fb578708390a659120821c70887b457e3c8e4f3edaa1e9b9c5ab00b70693cd"
    sha256 cellar: :any_skip_relocation, ventura:        "22fb578708390a659120821c70887b457e3c8e4f3edaa1e9b9c5ab00b70693cd"
    sha256 cellar: :any_skip_relocation, monterey:       "22fb578708390a659120821c70887b457e3c8e4f3edaa1e9b9c5ab00b70693cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6f218de19e9ebf60136ef483a57723e9478783af27b8678576075d22fb75e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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

    Open3.popen3("#{bin}tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.18.tgz"
  sha256 "984bc9fcff05ab5d45d9c52ac1f0934fdab513688ff8733c5783877e155c35a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70e7b172b5022d883fda5586b9d46f55f7f2c9dc95bc7ac7ef877e66da15cb9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e7b172b5022d883fda5586b9d46f55f7f2c9dc95bc7ac7ef877e66da15cb9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e7b172b5022d883fda5586b9d46f55f7f2c9dc95bc7ac7ef877e66da15cb9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fcd18925ccd56a4ae0c30e1b3ea1554050e44690fa70ff1a9d76edd47d6e6c8"
    sha256 cellar: :any_skip_relocation, ventura:        "6fcd18925ccd56a4ae0c30e1b3ea1554050e44690fa70ff1a9d76edd47d6e6c8"
    sha256 cellar: :any_skip_relocation, monterey:       "6fcd18925ccd56a4ae0c30e1b3ea1554050e44690fa70ff1a9d76edd47d6e6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c0c49736314d41d5dd57f8998a903676579a6fabc9777bbd36dc426b9902df"
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
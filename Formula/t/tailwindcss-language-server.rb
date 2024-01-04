require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server#readme"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.15.tgz"
  sha256 "11bb9bdf55be35e90da5f96f957a42965aa956bc22087eb9e33b67c42df01d7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb89fffab31c622733017e0932440f4840e47d498acb9a19988019aa4745c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb89fffab31c622733017e0932440f4840e47d498acb9a19988019aa4745c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb89fffab31c622733017e0932440f4840e47d498acb9a19988019aa4745c82"
    sha256 cellar: :any_skip_relocation, sonoma:         "043a48e115659143ced899e5729086267f8d0659902ea21fcd60834dd08d79f6"
    sha256 cellar: :any_skip_relocation, ventura:        "043a48e115659143ced899e5729086267f8d0659902ea21fcd60834dd08d79f6"
    sha256 cellar: :any_skip_relocation, monterey:       "043a48e115659143ced899e5729086267f8d0659902ea21fcd60834dd08d79f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea4a1af27f8dfa874c5bd6018d74b7b96bec5d57211e87fce355b89aa0c9901"
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
class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.26.tgz"
  sha256 "0bb38dad8ffbe650c1b410272a39f711a44700618e66ff59191d5dd260d4d475"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "161f901f79ec9bcc961dc63243634c333a32f783cbe996eb846306eb0fe200bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "604e1efabdbe9b9d5abcc5f6a5566f939a684d66af41bb7361ba4e7069eef1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "604e1efabdbe9b9d5abcc5f6a5566f939a684d66af41bb7361ba4e7069eef1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db26b38216814c794d140567f267766664add80c1112a3c9c0e3ce06f2500481"
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
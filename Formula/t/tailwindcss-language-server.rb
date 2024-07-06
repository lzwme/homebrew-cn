require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.20.tgz"
  sha256 "ca46edd2118850c1bd6c5a68488882d2e6857450e184da634de03d1ee37b48eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64ad69572761a75d5fb80b45bb388379fe6a4bf8788ef43718f4944092f4bf91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ad69572761a75d5fb80b45bb388379fe6a4bf8788ef43718f4944092f4bf91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64ad69572761a75d5fb80b45bb388379fe6a4bf8788ef43718f4944092f4bf91"
    sha256 cellar: :any_skip_relocation, sonoma:         "c012c4cdb6fd9e61dbeb55ba0c24ace83b8b12681a8fabd70da4b4cb58d34752"
    sha256 cellar: :any_skip_relocation, ventura:        "c012c4cdb6fd9e61dbeb55ba0c24ace83b8b12681a8fabd70da4b4cb58d34752"
    sha256 cellar: :any_skip_relocation, monterey:       "c012c4cdb6fd9e61dbeb55ba0c24ace83b8b12681a8fabd70da4b4cb58d34752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfcf5ed8013e222c937c09f27f2ed8fdef1c8d70c38666086b10cda35246078"
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
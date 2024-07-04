require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.19.tgz"
  sha256 "d4b72a0292f2a0d6fa540d02cd72dae6b9cf7cb11c31d4ee69a193f60bb9fad9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6e8cd06c1937417ca21f93b1d6ecfc3665c36c2674def435f7ad55b32a06a00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6e8cd06c1937417ca21f93b1d6ecfc3665c36c2674def435f7ad55b32a06a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6e8cd06c1937417ca21f93b1d6ecfc3665c36c2674def435f7ad55b32a06a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e74a1d241b97bcce96c4e70e7e1fa2bb0e0a71caf34081809046d46d38bbace"
    sha256 cellar: :any_skip_relocation, ventura:        "2e74a1d241b97bcce96c4e70e7e1fa2bb0e0a71caf34081809046d46d38bbace"
    sha256 cellar: :any_skip_relocation, monterey:       "2e74a1d241b97bcce96c4e70e7e1fa2bb0e0a71caf34081809046d46d38bbace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64591763a0f9a8f525837dd9e3020998a5e25744de17420656b877e0b4360889"
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
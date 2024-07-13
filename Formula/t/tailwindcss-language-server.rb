require "languagenode"

class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.21.tgz"
  sha256 "8df99f2ef9bb68759cdfa7cf6fa3a1da10de99217a0d94f0ed55765beb3831b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09713733f9477fd87a6b1372a3c37df8513633be5d17e8f8d37856c463c707d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09713733f9477fd87a6b1372a3c37df8513633be5d17e8f8d37856c463c707d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09713733f9477fd87a6b1372a3c37df8513633be5d17e8f8d37856c463c707d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "822e1cdd528c3e1d0b81afdca82a3a9c73504c5ec6b01a1c5b19c1204b246dd3"
    sha256 cellar: :any_skip_relocation, ventura:        "822e1cdd528c3e1d0b81afdca82a3a9c73504c5ec6b01a1c5b19c1204b246dd3"
    sha256 cellar: :any_skip_relocation, monterey:       "84919cdbe25e334bead4a21d1a1d73a25722fd33d7a69ec7ea130fba7cf5a31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3ca13a77ad23454ecdf5b568ec9c836a96ad358c8bb5cb5cfab8387888dbea"
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
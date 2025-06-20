class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.23.tar.gz"
  sha256 "31b06eb01c6f446c3e5dbc0e116eac7dd039c57cd7f74dff693c7af44319b857"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee957b1b9813f3c65c5c15f1ef5c2fc8fcc407607445176a8b243871b3c4d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee957b1b9813f3c65c5c15f1ef5c2fc8fcc407607445176a8b243871b3c4d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee957b1b9813f3c65c5c15f1ef5c2fc8fcc407607445176a8b243871b3c4d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ee957b1b9813f3c65c5c15f1ef5c2fc8fcc407607445176a8b243871b3c4d6b"
    sha256 cellar: :any_skip_relocation, ventura:       "3ee957b1b9813f3c65c5c15f1ef5c2fc8fcc407607445176a8b243871b3c4d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a3d71b29adac6e061c4feb04df7b498969e61a35873605486ba70d0b141310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a3d71b29adac6e061c4feb04df7b498969e61a35873605486ba70d0b141310"
  end

  depends_on "pnpm@9" => :build
  depends_on "node"

  def install
    cd "packagestailwindcss-language-server" do
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "run", "build"
      bin.install "bintailwindcss-language-server"
    end
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
class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.2.tar.gz"
  sha256 "5022a6352a804210b70780cf269492de60d4f56cdde9b2ddd9c6a6826a7294d3"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfa33a70b068547aaef1c0b3b89f4c928a2f9efcba6c67fd098a5a3c39bc197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbfa33a70b068547aaef1c0b3b89f4c928a2f9efcba6c67fd098a5a3c39bc197"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbfa33a70b068547aaef1c0b3b89f4c928a2f9efcba6c67fd098a5a3c39bc197"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfa33a70b068547aaef1c0b3b89f4c928a2f9efcba6c67fd098a5a3c39bc197"
    sha256 cellar: :any_skip_relocation, ventura:       "bbfa33a70b068547aaef1c0b3b89f4c928a2f9efcba6c67fd098a5a3c39bc197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17b5ed40dc01aa037bd9ed8b21e4ea24a653407c2b8cb1d25b7a472e5905d48"
  end

  depends_on "pnpm" => :build
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
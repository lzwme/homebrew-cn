class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.7.tar.gz"
  sha256 "9b5c286505d811c405ea5bd64ad52489cc24b0e5157e8180009ead1ebd3f1757"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, ventura:       "c68b1e9ff38725229e830d1d7bc268d11d20eff19460271ca92955bdf88ddcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536e004ac72328a1654de652cda949c00073cbc1777e467def92e106a00830a9"
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
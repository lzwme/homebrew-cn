class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.13.tar.gz"
  sha256 "04958fb77b1c7f73f5c7207b875c27166de51ff4c34b97769136ae78332a39a6"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65ecfed4214a117a773ed93169431221919a5325cf950e4d901098c222ab6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65ecfed4214a117a773ed93169431221919a5325cf950e4d901098c222ab6de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a65ecfed4214a117a773ed93169431221919a5325cf950e4d901098c222ab6de"
    sha256 cellar: :any_skip_relocation, sonoma:        "a65ecfed4214a117a773ed93169431221919a5325cf950e4d901098c222ab6de"
    sha256 cellar: :any_skip_relocation, ventura:       "a65ecfed4214a117a773ed93169431221919a5325cf950e4d901098c222ab6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5870df49080d297ff66c51f13fe5650be3591e2f818335469898ef9059172fe"
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
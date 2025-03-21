class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.11.tar.gz"
  sha256 "a35e218b7523cd9dc2e196b7bcee61cb439f648874da9b88b142369296b2dda2"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bade2aa55e555ea502d38092d203461ab87959a64f4253f5cb0527a8a2cff74a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bade2aa55e555ea502d38092d203461ab87959a64f4253f5cb0527a8a2cff74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bade2aa55e555ea502d38092d203461ab87959a64f4253f5cb0527a8a2cff74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bade2aa55e555ea502d38092d203461ab87959a64f4253f5cb0527a8a2cff74a"
    sha256 cellar: :any_skip_relocation, ventura:       "bade2aa55e555ea502d38092d203461ab87959a64f4253f5cb0527a8a2cff74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ded5ee32fd931a8928c79a902c91cffbdc1c20dfe6f2a01197cfc8e18b49804"
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
class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.22.tar.gz"
  sha256 "5b1b1b8bc19a3a7b33d4829da67a0052ae8cc1b05d6cdf27d51f0a5d2e0c5e53"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834a8ffdedf0ab4655e4ea86383fe57d5988bc4bcafc41f17d08bec5f2c7f94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "834a8ffdedf0ab4655e4ea86383fe57d5988bc4bcafc41f17d08bec5f2c7f94c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "834a8ffdedf0ab4655e4ea86383fe57d5988bc4bcafc41f17d08bec5f2c7f94c"
    sha256 cellar: :any_skip_relocation, sonoma:        "834a8ffdedf0ab4655e4ea86383fe57d5988bc4bcafc41f17d08bec5f2c7f94c"
    sha256 cellar: :any_skip_relocation, ventura:       "834a8ffdedf0ab4655e4ea86383fe57d5988bc4bcafc41f17d08bec5f2c7f94c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e895228ef439e3e6ef2fd9b3a0b2ac01750ba6ef5c6bcb3e41e68e6ee12a8542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e895228ef439e3e6ef2fd9b3a0b2ac01750ba6ef5c6bcb3e41e68e6ee12a8542"
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
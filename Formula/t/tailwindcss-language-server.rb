class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.4.tar.gz"
  sha256 "da3412c0af5471dbc9d4510ca967c3d90e7db49ffea0cee5d7a3821fba5e07eb"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ac53ce0d54e27bdf5696519421f4178e7af751299a5d6a1e174e9b6dc2050a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ac53ce0d54e27bdf5696519421f4178e7af751299a5d6a1e174e9b6dc2050a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11ac53ce0d54e27bdf5696519421f4178e7af751299a5d6a1e174e9b6dc2050a"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ac53ce0d54e27bdf5696519421f4178e7af751299a5d6a1e174e9b6dc2050a"
    sha256 cellar: :any_skip_relocation, ventura:       "11ac53ce0d54e27bdf5696519421f4178e7af751299a5d6a1e174e9b6dc2050a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6bbcc315a6d074d5d5e73f5381a9c611ffd9c11b531773275019123450fed8"
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
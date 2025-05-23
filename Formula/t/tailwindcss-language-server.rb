class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.19.tar.gz"
  sha256 "f3934e29bc6c759ec1d3788c423975c56a8ec67d18e5b021212308fca6a7aee5"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526387170fa7222aaf213e7d1416df64d6468945ba39cfe45cd5d1403192eca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526387170fa7222aaf213e7d1416df64d6468945ba39cfe45cd5d1403192eca4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "526387170fa7222aaf213e7d1416df64d6468945ba39cfe45cd5d1403192eca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "526387170fa7222aaf213e7d1416df64d6468945ba39cfe45cd5d1403192eca4"
    sha256 cellar: :any_skip_relocation, ventura:       "526387170fa7222aaf213e7d1416df64d6468945ba39cfe45cd5d1403192eca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0787d06c03ba508ce6ef06f6a6f5bfe53e4e8442bfd27419ba3da80e506341a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0787d06c03ba508ce6ef06f6a6f5bfe53e4e8442bfd27419ba3da80e506341a"
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
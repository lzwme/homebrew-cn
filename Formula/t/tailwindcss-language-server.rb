class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.1.tar.gz"
  sha256 "b2f0d3ec0cfc9e14114455e0207bf206c7c88ac52f68ae9cd464abe7b3435bc1"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78616e83cf058326be0e2253b01ec5179e08cacb0c26cd11b20646b65e739194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78616e83cf058326be0e2253b01ec5179e08cacb0c26cd11b20646b65e739194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78616e83cf058326be0e2253b01ec5179e08cacb0c26cd11b20646b65e739194"
    sha256 cellar: :any_skip_relocation, sonoma:        "78616e83cf058326be0e2253b01ec5179e08cacb0c26cd11b20646b65e739194"
    sha256 cellar: :any_skip_relocation, ventura:       "78616e83cf058326be0e2253b01ec5179e08cacb0c26cd11b20646b65e739194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c940a574eaf55b229298cc93645812a5652f60be74f25456b13b1e6fb852be6"
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
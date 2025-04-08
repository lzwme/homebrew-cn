class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.14.tar.gz"
  sha256 "9206cfc750153f1e4c8ba963591035c36896cedfc8223bb85a77b2dc78556083"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf945ea77cbe06127a3478063db4bff606df6df401b7622420f3253830a8d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf945ea77cbe06127a3478063db4bff606df6df401b7622420f3253830a8d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecf945ea77cbe06127a3478063db4bff606df6df401b7622420f3253830a8d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf945ea77cbe06127a3478063db4bff606df6df401b7622420f3253830a8d9e"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf945ea77cbe06127a3478063db4bff606df6df401b7622420f3253830a8d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af79065c4fa7ec6f73bd98bdfc483faf3ede2bb62b669a085ba006f855f90c2b"
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
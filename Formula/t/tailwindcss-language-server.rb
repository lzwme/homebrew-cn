class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.18.tar.gz"
  sha256 "655c18ac56664e8b3a19d76fecc908ceafbc8daca6b799927f8b2ee74eb0afb8"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdeea6a5d16301512a238d9f4c5a6f0bebaa68c5a4e3996a21a7cbee447f6c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdeea6a5d16301512a238d9f4c5a6f0bebaa68c5a4e3996a21a7cbee447f6c99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdeea6a5d16301512a238d9f4c5a6f0bebaa68c5a4e3996a21a7cbee447f6c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdeea6a5d16301512a238d9f4c5a6f0bebaa68c5a4e3996a21a7cbee447f6c99"
    sha256 cellar: :any_skip_relocation, ventura:       "fdeea6a5d16301512a238d9f4c5a6f0bebaa68c5a4e3996a21a7cbee447f6c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a09742e4a001919980d0eabaebd66caefa0cd81bbfedd838eb4755c84bc040b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a09742e4a001919980d0eabaebd66caefa0cd81bbfedd838eb4755c84bc040b"
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
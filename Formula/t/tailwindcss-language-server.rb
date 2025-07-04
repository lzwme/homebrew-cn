class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.24.tar.gz"
  sha256 "050a94e72ee374a301af534d382148ae24a6af8018f831059bf988178e248c32"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a819ff124d05c1cd96aa2307d07fb3559e7170b417e8d3a94def2e2fc900cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a819ff124d05c1cd96aa2307d07fb3559e7170b417e8d3a94def2e2fc900cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a819ff124d05c1cd96aa2307d07fb3559e7170b417e8d3a94def2e2fc900cd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a819ff124d05c1cd96aa2307d07fb3559e7170b417e8d3a94def2e2fc900cd1"
    sha256 cellar: :any_skip_relocation, ventura:       "5a819ff124d05c1cd96aa2307d07fb3559e7170b417e8d3a94def2e2fc900cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158ba553ff3bbdcab693865410f17ad341432a76efc1f295623a7205eeb3cf9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158ba553ff3bbdcab693865410f17ad341432a76efc1f295623a7205eeb3cf9a"
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
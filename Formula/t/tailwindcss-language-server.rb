class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.17.tar.gz"
  sha256 "861bc0b74370a9ad577edb05f170e57e197ae06bb16cf4abd8cc33c0f63a594c"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c5a8abd892befae22f19ded8a3cf1407d084ebe36105404bfc83f9e0456e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c5a8abd892befae22f19ded8a3cf1407d084ebe36105404bfc83f9e0456e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1c5a8abd892befae22f19ded8a3cf1407d084ebe36105404bfc83f9e0456e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1c5a8abd892befae22f19ded8a3cf1407d084ebe36105404bfc83f9e0456e36"
    sha256 cellar: :any_skip_relocation, ventura:       "f1c5a8abd892befae22f19ded8a3cf1407d084ebe36105404bfc83f9e0456e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a9d5da0f54a86b1c4d8e0adf416207eec2bfb807d83ab43ed46a62c714c0767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9d5da0f54a86b1c4d8e0adf416207eec2bfb807d83ab43ed46a62c714c0767"
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
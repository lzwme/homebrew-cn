class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.12.tar.gz"
  sha256 "ae5d2ca5edb60718d5e6e28501abec11787a762e4d1193f60f3fb3928924efa7"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff81812f11b7382050bcc32a1dcdd5d28b4849b9ce8a328cabd07714bcaea8c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff81812f11b7382050bcc32a1dcdd5d28b4849b9ce8a328cabd07714bcaea8c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff81812f11b7382050bcc32a1dcdd5d28b4849b9ce8a328cabd07714bcaea8c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff81812f11b7382050bcc32a1dcdd5d28b4849b9ce8a328cabd07714bcaea8c5"
    sha256 cellar: :any_skip_relocation, ventura:       "ff81812f11b7382050bcc32a1dcdd5d28b4849b9ce8a328cabd07714bcaea8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92761319602b2a5e12af7926626458fb7a325798ab1f84dcce749d69f97e1a64"
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
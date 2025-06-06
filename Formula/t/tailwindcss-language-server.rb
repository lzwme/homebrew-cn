class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:github.comtailwindlabstailwindcss-intellisensearchiverefstagsv0.14.21.tar.gz"
  sha256 "2f4b59f568af0da337e5f182bc4bc32622c9261c94de79e2133913031103ece3"
  license "MIT"

  livecheck do
    url "https:registry.npmjs.org@tailwindcsslanguage-serverlatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bc8613bdeee598377f8506f4796854c0c8f41abe8f4b3cb828ddc36f9841b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc8613bdeee598377f8506f4796854c0c8f41abe8f4b3cb828ddc36f9841b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bc8613bdeee598377f8506f4796854c0c8f41abe8f4b3cb828ddc36f9841b2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc8613bdeee598377f8506f4796854c0c8f41abe8f4b3cb828ddc36f9841b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc8613bdeee598377f8506f4796854c0c8f41abe8f4b3cb828ddc36f9841b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "737dc21aa59c7dacb473883ef473564eeb67e77a07625cca9a640f0ae1306be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737dc21aa59c7dacb473883ef473564eeb67e77a07625cca9a640f0ae1306be5"
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
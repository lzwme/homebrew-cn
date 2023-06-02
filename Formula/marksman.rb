class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://ghproxy.com/https://github.com/artempyanykh/marksman/archive/refs/tags/2023-06-01.tar.gz"
  version "2023-06-01"
  sha256 "1b619b450c326975dc37d16179313371aafb19932d63d18616bae13e3c1b2065"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bdeca2ca970d3c67e8519f56da218e445886ba9cdde4450b9936aefeca51dcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43450f1c1bc6f0a5e6580a1a745532fce34d1d268837a569ed11f66b8c41449"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d44187ec850e12b672daff8a61451249d4379d52cb4319a015d0dcd653c2d5"
    sha256 cellar: :any_skip_relocation, ventura:        "d54950c591b71ecc0c70432af06a7ecbfd00342f17c1347fd42f2b6aa4e58e51"
    sha256 cellar: :any_skip_relocation, monterey:       "46b9c225ac874ed8e3fc837b95ca39d84af93b3bedd24fae6fd591d1de22b2ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "02e5bcf17477a2b535b97b9aa45846582ae9246732392b1269e8aafc62b3334b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3091d62964cf55721f9c34a739faaeb61d89a43898afefbf6a0e70c4a6f00116"
  end

  depends_on "dotnet" => :build

  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    # by default it uses `git describe` to acquire a version suffix, for details
    # see the GitHub pull request [1], the resulting version would for example
    # be `1.0.0-<version>`
    #
    # [1]: https://github.com/artempyanykh/marksman/pull/125
    ENV.deparallelize do
      system "make", "VERSIONSTRING=#{version}", "DEST=#{bin}", "publishTo"
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

    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    Open3.popen3("#{bin}/marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
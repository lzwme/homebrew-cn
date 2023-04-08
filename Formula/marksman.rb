class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://ghproxy.com/https://github.com/artempyanykh/marksman/archive/refs/tags/2023-04-06.tar.gz"
  version "2023-04-06"
  sha256 "c5e49046fe55ede0d8dabf71c83710476ca1735cb218bea240765812f879a9c1"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d0f7c3ad9cc843c762d5e2c37011455bfdde2b2e4e9c8afed91ca7ebb60fab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1968774940c5bdca1dc74ddb6b18b01a440f723236506ff8f88104e250cc4aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c00b261b071c337325788bd6e433907d18afe7154b1da88a3a2d436790968063"
    sha256 cellar: :any_skip_relocation, ventura:        "a4bac51a79b56260a0b2d2f9beef4e0b877b7a37804a414033b39398d9ecb722"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d83365135eeddc9709ed476f5fa38034b8cd13d21344bb21c73959be91f5f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6b0af395c5d2bf015a8bfb4b6bdbb7a26e064290bacd9dab43ac1d792b76db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1a0b1f67cb7047ffe450a73bd84983ee6efd1f1f78eeee832ab6c77a1950c4"
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
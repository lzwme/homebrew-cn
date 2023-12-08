class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://ghproxy.com/https://github.com/artempyanykh/marksman/archive/refs/tags/2023-12-07.tar.gz"
  sha256 "b0fff091b87abfaccefc6276ed07e9bc35ecf43da197049a7295db175d593748"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4f1d6de07356d9cd0785a251bd24b171695d9ed45836b9178780b23a633fbbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e25f02303d8cd7015adc3427aa3bc88988418cb5344454057c84f2919a1cdb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "975ae37e4d9d34b24bdcc68a5bae6efde5944eb9f5cdba3ca819f79b1ae16f9f"
    sha256 cellar: :any_skip_relocation, ventura:        "1f461065528fb9523f1e1e9f63cc8945c487cc5886d0825b9d05826f3f70bee5"
    sha256 cellar: :any_skip_relocation, monterey:       "ee06e585cc2b152b6f67251d2da195a062bfd9c1ffbe270bfb6f421a9882a103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db36a765cdea49355d0e150aa6bda5587b2a2cfae8815ec220afcf8449d2a82a"
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
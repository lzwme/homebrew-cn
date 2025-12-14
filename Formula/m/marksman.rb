class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://ghfast.top/https://github.com/artempyanykh/marksman/archive/refs/tags/2025-12-13.tar.gz"
  sha256 "7dcfb73538690d16950aa43a78aa58c1c144548851797e6088d3e76cd8a3f2ba"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f3b1ded7394ecf60b8f983a7b193cc9238fbe990417fb0042e5665181735b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef7f4825ba61c2b03ba99df7fafea0d5d734962dee2f0d045d493a4283e6cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b6b6c483db7f39e01a4549370ede29ae8b8c1012ce2ac7aeb58ea2eb0d553e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8354ec0cacf7045a5a7089f0ae1dce2f0820f5e4a5319de81eafb68a00a839fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ea482c5ee1ea3806cc72053a63e1bde0033d21af843dff723a0b2bc76b150a"
  end

  depends_on "dotnet"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:DebugType=embedded
    ]
    args << "-p:VersionString=#{version}" if build.stable?

    system "dotnet", "publish", "Marksman/Marksman.fsproj", *args
    (bin/"marksman").write_env_script libexec/"marksman", DOTNET_ROOT: dotnet.opt_libexec
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

    Open3.popen3(bin/"marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
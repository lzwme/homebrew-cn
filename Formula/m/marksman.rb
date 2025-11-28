class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://ghfast.top/https://github.com/artempyanykh/marksman/archive/refs/tags/2025-11-25.tar.gz"
  sha256 "cd42792e963123a832fd802cd08ada4b7beb04c239d882c2f6d93ea172979a43"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9e5af4f44802544a108f641ffc6f2d49ff188c3a8eb0e9ceb3871657fbe1c2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107cf47ab629689b971cf98e3f102e72ce2b5470aed2abd3c1044a6ac19c00c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20798205d9e34db867a257b9e7164ee6b531e2248148c2c7a0156d41862d7f45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfb7e5658fccfdedd88fd8d9fffc8f668276096c46935d8148f25eead5c3b152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908f8c833798fbbd2eb5881b19ba51a99f4db2f761281a8f672d714e2afe4d74"
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
class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https:github.comartempyanykhmarksman"
  url "https:github.comartempyanykhmarksmanarchiverefstags2024-12-04.tar.gz"
  sha256 "d53791f6c055ad9b88a0b1d80d17e267b60031e82aa15807283f7488cd01d876"
  license "MIT"
  head "https:github.comartempyanykhmarksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c0702b85efb3f4162cd313f39579b7cc31632cb114ff394f8ea31487b5dc10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "422ff3a6719c51d5220856fa6405eaaec745fc89c168f404c359fd2f594b5d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7470dd4060eb0e24698ca213cb96504912e83c642ef245dfd3a1e3ac56f351e2"
    sha256 cellar: :any_skip_relocation, ventura:       "b5c65348681ce0b6dc8da206d2f3e2c0d06274035bb11069a867359e4833f219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58cd917677e72f8f856ac84a8eb41241285d6cceed4c353faa4157b2ebe798cc"
  end

  depends_on "dotnet@8"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@8"]
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

    system "dotnet", "publish", "MarksmanMarksman.fsproj", *args
    (bin"marksman").write_env_script libexec"marksman", DOTNET_ROOT: dotnet.opt_libexec
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

    Open3.popen3(bin"marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end
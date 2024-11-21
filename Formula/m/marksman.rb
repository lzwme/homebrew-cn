class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https:github.comartempyanykhmarksman"
  url "https:github.comartempyanykhmarksmanarchiverefstags2024-11-20.tar.gz"
  sha256 "7c93a6a75444c17573074bbeed8ecfe4f26ae6877d7f0c7ae20a4b55daad37d2"
  license "MIT"
  head "https:github.comartempyanykhmarksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b747519c4b680cb5dfdd0abe574492dec614316f1ff58b1dc12bb32c89e78888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c03c2c3e1e2ae9d3029dfb148648da8a366013a7b4dca81ea583c3e00830bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68e31b63094eecbaac8c4f296118d82f143efc68d0710f12a10e7732a49881d8"
    sha256 cellar: :any_skip_relocation, ventura:       "c02e49622a537a298aa65af5a19d1038d9ac4ad2f3410ed572cc0ecf1e4df791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015a9ccb9ada884d3a28b1253471a03575721f492b415bc4166e502d879b1b6a"
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
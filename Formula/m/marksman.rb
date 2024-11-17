class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https:github.comartempyanykhmarksman"
  url "https:github.comartempyanykhmarksmanarchiverefstags2024-10-07.tar.gz"
  sha256 "4b3c107717344508c8de66efe4a847d31a8f77040908cccfef1f3deec4ffad96"
  license "MIT"
  head "https:github.comartempyanykhmarksman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91742130129cda2d4af22130ecadba1c607521a57e97b3cef6533e6b5a760184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2df0f1701aed534d6611f4b2cc70af65cabfefc14d9139ae49d26223da11cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc21bbe15887f9e92c8b07cb10ce2a419cf85d3ae99f89f9932cb0cb152de1de"
    sha256 cellar: :any_skip_relocation, ventura:       "afbc97b611b2651eef931c4979b662f5bfc5b207db95e9601732b871489de782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c4ba93d8946408b3963f273c424e2eff140c06d74ea8178635a6c45237185e"
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
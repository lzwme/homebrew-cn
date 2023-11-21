class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghproxy.com/https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2ee856c667d14f2b6a7f4081b330a8d9e9b0af18923aebacc88ed092736d7bd6"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "417e819cd53ff31758904737aa81b97d0f7cb878ec2e80b252565bfe957753a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8daa09c8de09315e51aaa0f5a0f12e79ea8aa9dc9e8f40ede2c1bde23b0b7023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d20c1d826d5defeabc4bd50fbe283f955273a71d513c60e1ef60199de64215"
    sha256 cellar: :any_skip_relocation, ventura:        "89bfb2c1c1dab4ae1415044ba517a14f332d972b3757e5acb553f96d44699548"
    sha256 cellar: :any_skip_relocation, monterey:       "feeddfa1702f211d8032be29b88cb967f4e591353ab3e6532aece9e718d0b2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e6de33fc2565f445539b9023f1c427770802835db1d4c8ead23d6023478157"
  end

  depends_on "dotnet"

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool",
                                       DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
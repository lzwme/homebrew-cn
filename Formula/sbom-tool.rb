class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghproxy.com/https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "93663e975abbc2e9a010bc955c6c984a7bd5451cab2c23be6446755764af1ef4"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "7c27aeb0cc343d7c38aaffa1b04488b385b2236d2da9b957a5ea9e7a4346fb55"
    sha256 cellar: :any_skip_relocation, monterey:     "7c27aeb0cc343d7c38aaffa1b04488b385b2236d2da9b957a5ea9e7a4346fb55"
    sha256 cellar: :any_skip_relocation, big_sur:      "7c27aeb0cc343d7c38aaffa1b04488b385b2236d2da9b957a5ea9e7a4346fb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3bd12ae1efa11135123a95197f06e864a1671f2cf7927ac6e947ae6cdd3f55b"
  end

  depends_on "dotnet" => :build
  # currently does not support arm build
  # upstream issue, https://github.com/microsoft/sbom-tool/issues/223
  depends_on arch: :x86_64

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    # the architecture is hardcoded to x64 for macOS due to to an issue with
    # the inclusion of dynamic libraries for the self-contained executable, for
    # details see: https://github.com/microsoft/sbom-tool/issues/223#issuecomment-1644578606
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = if OS.mac? || Hardware::CPU.intel?
      "x64"
    else
      Hardware::CPU.arch.to_s
    end

    args = %W[
      --configuration Release
      --output #{buildpath}
      --runtime #{os}-#{arch}
      --self-contained=true
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    bin.install "Microsoft.Sbom.Tool" => "sbom-tool"
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
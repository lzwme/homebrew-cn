class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https:github.commicrosoftsbom-tool"
  url "https:github.commicrosoftsbom-toolarchiverefstagsv2.2.8.tar.gz"
  sha256 "f7017b0a38cd8fee05024ccb6dbfd9e450219fa3b34bd21a2eaed47eebe2feeb"
  license "MIT"
  head "https:github.commicrosoftsbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eae242ff1d396cb1507e183b38c3672c721479328ec844a87682c8f8bdeac7c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "544469250cf66b0fec62d930535356453fa4f953511c07ec6819b80658ca1845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34adeb45f26b3604f96eb214acabd3272c2e93ecbf54949f54a696457f267388"
    sha256 cellar: :any_skip_relocation, sonoma:         "28b70b2c81c8fd0617b836d69ab2278aea47929984ea4700156a7550658c11cc"
    sha256 cellar: :any_skip_relocation, ventura:        "44d9ce3dde4cc6b82cd66bf94d3cdf8389d78a9e51f1f2378934c01a02f8329b"
    sha256 cellar: :any_skip_relocation, monterey:       "2aabfaa7ea134f570d9b1a9e1e7e47b96b81a64bc39b776c101372009a7ab663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9818d2779d7859ebca588ac7c9480a8143d3940d8db59ca9f900fddc44ab8c85"
  end

  depends_on "dotnet"

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

    system "dotnet", "publish", "srcMicrosoft.Sbom.ToolMicrosoft.Sbom.Tool.csproj", *args
    (bin"sbom-tool").write_env_script libexec"Microsoft.Sbom.Tool",
                                       DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb https:formulae.brew.sh
    ]

    system bin"sbom-tool", "generate", *args

    json = JSON.parse((testpath"_manifestspdx_2.2manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
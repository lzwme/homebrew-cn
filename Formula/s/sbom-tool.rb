class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https:github.commicrosoftsbom-tool"
  url "https:github.commicrosoftsbom-toolarchiverefstagsv4.0.2.tar.gz"
  sha256 "d43efd0ff2444c98102cde9c584bef96db3e740c31e5c5b2b5af68a65940d6b7"
  license "MIT"
  head "https:github.commicrosoftsbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b43e167fd92bd6766467dd211e96af259d8c219ed962e6ed456cb8125753d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4d060153e9ebcad5034a6b6c1bfd4c8451701e4d932751b7106edafd1308b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a09960d083006bb438f5b273520851574e24220ffd1d40a23389527a7b109d96"
    sha256 cellar: :any_skip_relocation, ventura:       "9c8584d1da9e547b774c93d3e3bd11bbf910f0a719dc4766d8c35326a90249da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3128fd9edae1d2d05749daa2bbe4ace7b1530adc31f4f80a6bf5b3414d3dff13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce597bc495dcb19eb349445dd17d584708e7eb198771adc65738972918408de"
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
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "srcMicrosoft.Sbom.ToolMicrosoft.Sbom.Tool.csproj", *args
    (bin"sbom-tool").write_env_script libexec"Microsoft.Sbom.Tool", DOTNET_ROOT: dotnet.opt_libexec
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
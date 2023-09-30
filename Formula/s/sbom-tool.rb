class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghproxy.com/https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "6f94eae4ee8584fed7ea1b006abdc4ecacdc1f6b496270fd81e710473184e27a"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd56e8c7ef8852d6fd3421ca8ff3195f8bd1967ed7fa64d19f6c53d0e7ba1874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd56e8c7ef8852d6fd3421ca8ff3195f8bd1967ed7fa64d19f6c53d0e7ba1874"
    sha256 cellar: :any_skip_relocation, ventura:        "ab4f295a3ea516222629dd787a2a0be5297a414bea22a35ad7d6f336019857d3"
    sha256 cellar: :any_skip_relocation, monterey:       "ab4f295a3ea516222629dd787a2a0be5297a414bea22a35ad7d6f336019857d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d1630c1f987e1053d542c0e8c66a0f5d4e1994c079277cde3dc318660711e8"
  end

  depends_on "dotnet" => :build

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  # patch to use mono.unix to support arm builds
  # upstream PR ref, https://github.com/microsoft/sbom-tool/pull/409
  patch do
    url "https://github.com/microsoft/sbom-tool/commit/dd411c551220fbb579e58c4464b284d2a6781080.patch?full_index=1"
    sha256 "d99878256a1ce470d0f424c86215ab07c5381cc29ee83c90129166899057a6fb"
  end

  def install
    bin.mkdir

    dotnet_version = Formula["dotnet"].version.to_s
    inreplace "./global.json", "8.0.100-rc.1.23463.5", dotnet_version

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

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
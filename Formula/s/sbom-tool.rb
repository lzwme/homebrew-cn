class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghproxy.com/https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "5aed29a68016cd248592735319ddebed25dc8d98957925f92791ecb1b91d9a53"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b776d2bcb7ec0b125a537e08a5a59b6a80887810f27d8593e7411d99d212c85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b776d2bcb7ec0b125a537e08a5a59b6a80887810f27d8593e7411d99d212c85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b776d2bcb7ec0b125a537e08a5a59b6a80887810f27d8593e7411d99d212c85"
    sha256 cellar: :any_skip_relocation, ventura:        "41e60ae2445044398eac8f93607c87651c9fc8b03ce61b4f2caa921888e1bd0e"
    sha256 cellar: :any_skip_relocation, monterey:       "41e60ae2445044398eac8f93607c87651c9fc8b03ce61b4f2caa921888e1bd0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e60ae2445044398eac8f93607c87651c9fc8b03ce61b4f2caa921888e1bd0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312a889d39c979b8e1e06747a145e84c2b671f4c04890b13f106c8a98b2cde66"
  end

  depends_on "dotnet" => :build

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    dotnet_version = Formula["dotnet"].version.to_s
    inreplace "./global.json", "7.0.400", dotnet_version

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
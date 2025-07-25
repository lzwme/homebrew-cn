class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghfast.top/https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "8f54fbcb463011633009f436e13f07e03423b2009b01d45fd6d6053459e37eea"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1897251a06b7c0fcd5e022522e93f088a454a627ff88fc6c2f2271076311b536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2592ca0021350c5d24225ecc77a8433c12da71272d6ff37ad1c1a7d5e7ec6dc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16bcc02d61099859ce9339b80075415c0a5cddfe87d0089f3031aa5013e79d42"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cde79fc411ef2da5fea8f23d1ff0cc1064dc183db9e39c8384e2d619bf1645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4774825ad211c3b780607e93c1f39a1d017fe9ea49dbcfbd4a27ebf237a7b7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e371252465a8e724e31df8caccede4144bb9745e7c992627aa03c3fae1bfc902"
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

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb https://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
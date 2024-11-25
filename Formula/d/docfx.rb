class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https:dotnet.github.iodocfx"
  url "https:github.comdotnetdocfxarchiverefstags2.78.1.tar.gz"
  sha256 "0f74a09a01cd5d1c2d130c64d798a874842f3f0e9dc04e199c140c54aa40271d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d41d1d6e709cf776ab61bc33de7d2fe60149533470431d3ad2a42886b606e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6db79a22471f7045a39bead6e4b3a61609aeaf70c201ea9ca42721341c8edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca7ae34cc6f4c6ab6119852052d77e167c4a1f5dc681a2d2697a42bed8308a6d"
    sha256 cellar: :any_skip_relocation, ventura:       "31d4bb33864581f36725d4bf9293d7f1dd83571284446cdc00bd079236114f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd055cea5a6d16f04387be5585fce0eec79d4d330630340a1b868d231b2e1b53"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https:github.comdotnetdocfxblobmainDirectory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "srcdocfx", *args

    (bin"docfx").write_env_script libexec"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin"docfx", "init", "--yes", "--output", testpath"docfx_project"
    assert_predicate testpath"docfx_projectdocfx.json", :exist?,
                     "Failed to generate project"
  end
end
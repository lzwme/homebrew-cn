class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https:github.comJustAman62undercut-f1"
  url "https:github.comJustAman62undercut-f1archiverefstagsv3.1.44.tar.gz"
  sha256 "e2016cf19b184a44557d4a89fe66937fa895abe834ee1b9b4c496ee0c7be6129"
  license "GPL-3.0-only"
  head "https:github.comJustAman62undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393c39bf49ccad140758dd223b8b28310c0d71f7eb782b8b0c9b0d69a73057a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5f6e5a70f920b28ba10a791ac64fcc9d7cddd1d88f3bd8a0a6ee81d1c07bc8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890534b7dd46ec41771a661304d7f0c4083f6907a96b9a9b484feffe8ff45d8d"
    sha256 cellar: :any_skip_relocation, ventura:       "f5b64f54beafee397e678b7a3d48e4b4309eba91947fd2c1e1d3dcedea07565e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df08d65910fc9db57280ab10eb55c321f47635e9053df447e5c501b5fce3bba"
  end

  depends_on "dotnet"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "mpg123"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:IncludeAllContentForSelfExtract=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:EnableCompressionInSingleFile=false
      -p:DebugType=None
      -p:PublicRelease=true
    ]

    # Version override is not needed if cloning from HEAD
    args << "-p:OverridePackageVersion=#{version}" if build.stable?

    system "dotnet", "publish", "UndercutF1.ConsoleUndercutF1.Console.csproj", *args

    (bin"undercutf1").write_env_script libexec"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}undercutf1 --version")

    output = shell_output("#{bin}undercutf1 import 2025")
    assert_match "Available Meetings", output
  end
end
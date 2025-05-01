class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https:github.comJustAman62undercut-f1"
  url "https:github.comJustAman62undercut-f1archiverefstagsv3.1.63.tar.gz"
  sha256 "3663512c24a0011dd19057fd509a69bb25bdc4b4ebae8b9697228055c813ce80"
  license "GPL-3.0-only"
  head "https:github.comJustAman62undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191d2cae26dc9329543ef62e7852fb557c072df5ce1ce59add644f25d48f83e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dddf01dd9cfa5624a43ed5c65fd52c883bbda91c0e0289d767075136ff1a39a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54af633538221602fd9ffa07d27e08818d21fa68ec7c782a95b2cd4bbd80c7e4"
    sha256 cellar: :any_skip_relocation, ventura:       "fca8e46b113973ead1f49ffe2b8a990202b73bdc9566d82b312f1bb2f9e212f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6671d2667bed5bab2da835a944cbe9f433b7868c6a054175171ed217a4558e"
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
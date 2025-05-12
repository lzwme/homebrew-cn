class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https:github.comJustAman62undercut-f1"
  url "https:github.comJustAman62undercut-f1archiverefstagsv3.1.85.tar.gz"
  sha256 "a3f1f6e5653b7babb66b95e6a149fe8cf755b511e43922e031c066d6fa2b8f58"
  license "GPL-3.0-only"
  head "https:github.comJustAman62undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825d3b2df028d04a8a40b52379f60c0091aadf4b6c2c9676463580733d5065fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd46cb5beadb80637ef57922e00b63dfc33263d648f84444961332e2faa2ffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e9aae1b9825d5f73325af75caa3667d88d9d2d769bca1d17d7c244701f8e6a4"
    sha256 cellar: :any_skip_relocation, ventura:       "23374e22ef467d6f6fefc001aad9444b9a976e5e26437f21cb229a98706dffcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610c45cd962355221acfc31cfacf924b5e3e829e108ad19df5e35237b09613f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98ab303a8414436a23178238933fa3e25a501632a1bf1ef84ebdd92073b95b3"
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
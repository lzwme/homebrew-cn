class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://ghfast.top/https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.73.tar.gz"
  sha256 "458e4a0ec263ff742adfb36ffa76b510c0639c5e671f440f10d2db8b21e4b6dc"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73cbe2f0cf106ffeb29f876ee764e0c47379772e4996bbf24f6a39faaca6a2f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6977b4550c42c623a41ff3e10c5aa7a4f36047d0478e81a7e2ef128adb58bd5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7955fc95391477944e6e7b1bbeefd5c35b8cc9c39b0055e6b11763774318be68"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c90735ce759a058eb45028c09bc87c7077e76884a9541a0ab7041f7c51c965e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17c3ac65cb398ef23fc219c0d0dd305568003465f9f9cea4c966791c0f94b84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436628a26fefd5f8cd4a3dd004841331fff07ec7fff72ee1da7ba6eedaed78d1"
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
      -p:PublishTrimmed=false
      -p:PublishAot=false
    ]

    # Version override is not needed if cloning from HEAD
    args << "-p:OverridePackageVersion=#{version}" if build.stable?

    system "dotnet", "publish", "UndercutF1.Console/UndercutF1.Console.csproj", *args

    (bin/"undercutf1").write_env_script libexec/"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/undercutf1 --version")

    output = shell_output("#{bin}/undercutf1 import 2026")
    assert_match "Received HTTP response headers after", output
  end
end
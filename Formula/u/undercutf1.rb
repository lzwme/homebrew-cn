class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://ghfast.top/https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.3.51.tar.gz"
  sha256 "fd1d577bc5aeaf869fefdde4c6b7e2894d705f62b4e327e3d0284bf0710e19ed"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aab82222f879b11534033e31b63042c6b9b025b01e7da94f9707c5a1d8d5969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d82b1ff2ff969f8f947357112235f01e7eab5ac3a93b439c2d6628ec6d7dc53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c93b23f3008a9bb5d282e93afb80b9edf123b701bd01dc55facb84ff43ff803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b8c29ce4861d6f5e4cc929fbcfd1d1d8b97142469d3ae221b90d01229a57e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90eee7f6455f5a16ecda3fc4d87e00d3a2befea45e296df9735bc9e9fbb36e14"
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

    system "dotnet", "publish", "UndercutF1.Console/UndercutF1.Console.csproj", *args

    (bin/"undercutf1").write_env_script libexec/"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/undercutf1 --version")

    output = shell_output("#{bin}/undercutf1 import 2025")
    assert_match "Available Meetings", output
  end
end
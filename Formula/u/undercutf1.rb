class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://ghfast.top/https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.2.23.tar.gz"
  sha256 "dc35be32355a18bee35b25123db27782f046f584991e1d2b00f60b47084d66ed"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea22f0c2841dc7c71b3b1ee2917ed805f608971322e6f4fb34c263317493cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d589998c3b1aaf221e0731a738feee8f4c1fe0924275ab2520d272f2124375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a5076dea03edd8ac2f58bd01873c5818a9aac761f5f53658a6a1b9437c13ee5"
    sha256 cellar: :any_skip_relocation, ventura:       "cf3099f2667c669b41caa9d60054bc014b71896ba587a26641ec33013facd2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce2d96abcece29d324291f052bbf8d03ead72e760bec8072f9fe9dcb00de20e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e040b54794d29dba0ad6f65fe3ef450a6748cf8376575e121f5549e03a4e3f1c"
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
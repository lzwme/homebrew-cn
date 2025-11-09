class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://ghfast.top/https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.4.12.tar.gz"
  sha256 "b84a9703f4c7ab052193708a62cc710bf26d0c566fb1a2f62d722e53d4c0f696"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e3f1e838110d7df03db96fed131bc5b76635687053bbda75814a4a563804754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11e1a87c824fcca711e3c7a3954a89dafd9308bf0553175cf84d6c55eac3504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1907c5401b4b89fcad225e85371b55966f032aefa495f1f4987b74a17e985887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a670255b05f61168fc7e5619ccaed2c4087e3716a694a862be689b6ccb901bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e881681de8f110bd9c3ec74bfa4a2ffaa2297c54b5298f907e0377d9664616"
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
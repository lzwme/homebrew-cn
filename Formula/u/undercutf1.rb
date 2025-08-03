class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://ghfast.top/https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "5d0103f2ce4147d676d740c72db7403da008b77b9b44f29a26ef6086e190c7e0"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d40a6c57aabe61ac23afecf5b2a98ebd655ded08641248ad145af73a89ee71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ab7b9b5bfbbc30239403b66cde713e567d31e28d47cf73934a2dca287ab941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a98d1a153ac98c6ab3af15e7fe3995531bb71d2f76e3ad2ab87604be4d3f51df"
    sha256 cellar: :any_skip_relocation, ventura:       "82a97a5739c5f5927d1ee236357b1c1e64c39771e722bea668896692b7ff18f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db8970985069c6710d8bcbabb681b67f22dccb6f3a59657d0454fbd2df8df902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf63925c12d5fdf1f97c41c3708e83ca10078c34ec198a31e67459b630ce17b"
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
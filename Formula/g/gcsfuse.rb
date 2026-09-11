class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.11.4.tar.gz"
  sha256 "ee8c135d308642ed39529c057650a5785f0122a07267eaab2c5618574d3fae76"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bec80953f12a28ddc93d8b1c54e82cf36700f315e759e70edcc2b16e51106e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "027cf369e8f33a8f524ef3a72869cd6667622611624187fc38c3fb8f60f20b73"
  end

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system bin/"gcsfuse", "--help"
    system sbin/"mount.gcsfuse", "--help"
  end
end
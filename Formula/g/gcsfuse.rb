class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "ae5f26ee6969081ecd71bdc581871ebb88cb7b03a00d3bab6f9939b80bcfa39a"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f052240d870d0d72f87f59b3d207909c46e8ebb772bd67af4e84d97b98ec938f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1d72e9034635e57667cdb39c676f0dbeabf3d255be9890600bb3af3276a1d653"
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
    system "#{sbin}/mount.gcsfuse", "--help"
  end
end
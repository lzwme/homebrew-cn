class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "a3c3a4185b53031df10147b02ecf7ece16083d98eb7768eae8a1e29fb97ac9f4"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "338fb5209b8cf71ed101be75e17ce3f035fd25828922901182e2da47543e926e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6a0dee643dc419ba6496f70c1d09f613250d97bb3ed22410cbb6529506dfe6cc"
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
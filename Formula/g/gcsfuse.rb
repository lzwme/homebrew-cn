class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "133f96085ef34974a53382aa8a65b064095ff889eff2aa98edf78f26e4a46299"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1701b49a255da5d7596ced7b0cf96cd3eaba95b108012dc43dba690c68a1b55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cfb057cad3e4b750fa2a1e846d81dea6560b8d8745baa8d684dbbffbc0cd2122"
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
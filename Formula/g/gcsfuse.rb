class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "0a090435c7cb851c3540fad903115fbe40cc39d4773c4b0dc147566ef6f8b368"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a7ac75d9de3f79a70c6c27fac675b7572a1a4fb6221b0f4d40504efa41ac0e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ecb7518ef138d51be3b0778e89d5cbb0e3c9b4a12cae39c4b6ede6d26ff8a071"
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
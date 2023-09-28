class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.0.1.tar.gz"
  sha256 "158a0179629a53aa5fd10a4837543a8ed2a0327a5ac185ec825a930caa9525e8"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1337852280f2983b20a8ef6896bd2b387a7760278098e642872878d690b20888"
    sha256 cellar: :any,                 arm64_ventura:  "9911c8d378c19e3c70410c1a194914edc8fd6d4f1932b7f846d1b4736f5a124d"
    sha256 cellar: :any,                 arm64_monterey: "2baff9b78da094fcdcd241b32d91365565bfade8c3f061efdbb7b146d261614c"
    sha256 cellar: :any,                 sonoma:         "cba25c1406ce77f156105ba65bc1d2639a6d12a2aa959341e68c1645c5835284"
    sha256 cellar: :any,                 ventura:        "22c3b440d92bca32ceb5ec651a281bb00592a22e0d011bc5c3f7767dfd45a934"
    sha256 cellar: :any,                 monterey:       "33043e9707f0c8734c31724d36426f58544c0c3bf9dfa182a5e46c827cf8e790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c5379c4e4a6a31ab34420322a6ff5a3801654d586503db41f666e116263f7f"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
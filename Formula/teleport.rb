class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.2.1.tar.gz"
  sha256 "ebffb1a9f94d3a74999c421d06964c93dcb4466f625ff287009a4bad922ec5fc"
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
    sha256 cellar: :any,                 arm64_ventura:  "f790eadac4aec644798abb702642fb2a67b13e5ac69d7b3d490a90743ffcc095"
    sha256 cellar: :any,                 arm64_monterey: "4f145116865078cf1f6a913f15e9b3c541daf31e6ca73d10b41cf4a273ed853f"
    sha256 cellar: :any,                 arm64_big_sur:  "eaaa18f93aee33593998b9ef1167c7ca6a788fa9acf552086716cb892f21ea01"
    sha256 cellar: :any,                 ventura:        "f6be5343da91c5579d64b211354613d6aaa3b945d1132926e9b5257dc61d79d0"
    sha256 cellar: :any,                 monterey:       "e2fea7d1ce972bc1ad9120900f08f2d58b160ff4699801298adc07e25c15dc34"
    sha256 cellar: :any,                 big_sur:        "e44e3b926730226cfb92101ef0319b30904328cc5164a975007e3568e33c2596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93bff0c3d2b27531dabdb774a904549fd1bf1c8fb459e2be422822a72245e0d4"
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
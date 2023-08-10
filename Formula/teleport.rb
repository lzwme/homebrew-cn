class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v13.3.2.tar.gz"
  sha256 "f0b2e4a24e7d6fc4c73e8b3fd90b34b839669ab1358a649efc29e24fc9ba3bcc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a96ee925548a6e8a933d4ac9a74ce1ede1ebd5e26bef9c516412c6b107e917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a9f84e59ff2e6edbeb9897a025337a7ebf022959e27b8c90402f62789181da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f84d29d5790d2ea8e18b35bec2d0a4226cca818d8d30cf59a4fe2be9656a2637"
    sha256 cellar: :any_skip_relocation, ventura:        "73d06a80f933d43329dd3298521f8d0cd8ced4ad3c0f28f9983ba6d090593391"
    sha256 cellar: :any_skip_relocation, monterey:       "3117177eac78e8de6c232baf1d0b18e660a7517ff50c465ce896443652ea626e"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd5e14ca160171c40cdeb5fe1232ef7f8baf3f679054c513d662800c1de2b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985b01d1a4e0109382acf8f877285fa0892d36418e7beaa3973952135c743a56"
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
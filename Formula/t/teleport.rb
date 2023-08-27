class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v13.3.6.tar.gz"
  sha256 "60ae2838919d7978a2dd29ddf5b3b0443e88183fbc943e6c93a2ad0722162f82"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e32c133da3abd287116d7a22ea013862c343549bdadfaabdd45200535a7a2ab9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b82a8dcca26aaa5fea48fb43ce80e5495bf3790048bbbbe8b2ded63a33489d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af29176047526f9d62ae8676523d2758f026a231d5303b2ae1dc06b137b23200"
    sha256 cellar: :any_skip_relocation, ventura:        "226d5207c1a8e5adff864f3d13d76c67f41c366104711d0cd8316478da76d314"
    sha256 cellar: :any_skip_relocation, monterey:       "75ceb50dcaad6e21b3b35dd86d3ee33fd9ec0ae242a3b68260dca370896ae4fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4313df3d0476c25676706c3cc892e59f4d92016ecdcf284efd70f233ef4c7fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741dbe09de73ce20e3f9ba8033d8a83df4a9fc20467d8d5b220263df8f7636dc"
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
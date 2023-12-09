class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.2.2.tar.gz"
  sha256 "46faea999a92e31798f674193e16549a5fbf286fce6e2dbf72e64b3c56e86238"
  license "AGPL-3.0-or-later"
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
    sha256 cellar: :any,                 arm64_sonoma:   "1e4501bd7ea0359b742a52f6e8f5c92c88f2c490e454d3cfdc071a3b699f8c03"
    sha256 cellar: :any,                 arm64_ventura:  "f1539e61fc5ed59750b2103862c05a3fc425d140660e915a381b54ff0530cade"
    sha256 cellar: :any,                 arm64_monterey: "62c48afa030110c1f045e204fe4c95d51eeb9fe446a888fb9badb4b6c76e1e8a"
    sha256 cellar: :any,                 sonoma:         "796a7c76d6df91fe1b55dbf5c55a7526344f78a83cb6b4ee148ca1f959ed6566"
    sha256 cellar: :any,                 ventura:        "b3da98a187949aa82e4c3358a191c3b0ba0cc0bbd74828fffe5b0f844f557cd7"
    sha256 cellar: :any,                 monterey:       "926b1576555823daea926af06959476281e299892e4f8c59610912f82922b97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ff8d7e35859a6364b6951f9c510c82bcd013667beceb09027f3cf859e9792d"
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
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v13.3.5.tar.gz"
  sha256 "276d97f10979233f2cafdbbbe634f9f5615fbf2f26825dcb15f3f83b96d71add"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1833f81f859ec8739d04e42633a27e448909b9f4a939dd3fc8cf2a9219f56dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d22629e94b4972ba56283615bfeafddb8c6db2907f6ad1f2f2442365675853"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af27cc8b83619a54e9397ca81d0f7374f696d6238e3715d9e4728034d2a32ccb"
    sha256 cellar: :any_skip_relocation, ventura:        "a5dfb494653c02bcd77b06633fa34fb73d5540aee0bbd9ef90de0b9aee1ae43a"
    sha256 cellar: :any_skip_relocation, monterey:       "b411df981ac063b4f079200f3eb2eda5a3a7ff4c8f9c5a4e43881f57109c1448"
    sha256 cellar: :any_skip_relocation, big_sur:        "26912b5b9bd2cca916ba24dc0c3f254eb711ad90b3b30f08c375d6494635a5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df63b6da036831a064255e5090f2e86df6cc4d1cc82d480fd450dc8d15b0ace"
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
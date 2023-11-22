class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "a1d6601320b58099ad228452b21d9c42f5f0908446cfb718e8842df5d34c28cb"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ef83fc0ff3dce8185a380102a0ed36694a95e778b6a24285d7be73cf672f62b3"
    sha256 cellar: :any,                 arm64_ventura:  "3396d0eb0d84d69edc7d6d8ff67b995f56bed69de2e707573bfcb7d44ad926db"
    sha256 cellar: :any,                 arm64_monterey: "5df707544232796ca3dacf8ff8a6424caf3c3273e9f17a4b53911ebc5bcf4906"
    sha256 cellar: :any,                 sonoma:         "94ba7f8f2a58bc7c7f9b2c91183e8f335ea453cf65e9333b5e3009e8fd643c32"
    sha256 cellar: :any,                 ventura:        "df41b1411bf657bde22856ca7e54a3577f7541ca72a9244e604b4064dc952c50"
    sha256 cellar: :any,                 monterey:       "70462df51141a0b81694f24504229ae8996ec5346db409ca5458aef3d7f487a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bba3a68ef22ca7d2ec92134445b02fd229bcd61b99682a3a99a0fdfc1c3ed65"
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
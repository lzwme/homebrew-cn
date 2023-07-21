class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.2.3.tar.gz"
  sha256 "df2741eae14dceb010bdaf8486081edd2de1eb14cead9f058ced8b46997b3abb"
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
    sha256 cellar: :any,                 arm64_ventura:  "c5ea499d34ec7131632514abd7162b294cbf2ebb8e1c091168f09e0d3d98213d"
    sha256 cellar: :any,                 arm64_monterey: "7f83dfbf6682b846296bc3986f6d7e9762c8b7570e1ace7c1d2b9987e97329bd"
    sha256 cellar: :any,                 arm64_big_sur:  "1b26591d90eda357cca09bdcd780b1c7f201f45001d1d8161d33a0162a1631fd"
    sha256 cellar: :any,                 ventura:        "5aa65d9c8e4c726da61540ae9813beb60e62825f12cab8b5208a9410012045d2"
    sha256 cellar: :any,                 monterey:       "e6af997a1820e3c3750d416a297b34541afd3f4be28f5e684368766a8de382dd"
    sha256 cellar: :any,                 big_sur:        "2a74e9f44657fde2e00d36d0b461bc466c4d0956c92a1ec8f44e0b7416157052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c8487554867a25e340e2fa62e7a1b6642a07cc28fdcceae64416255ca18eaf"
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
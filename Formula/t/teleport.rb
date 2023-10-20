class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "63afee5bbcc6508b2c0e6fd76868302061161961654494f4451d438cf4d431c1"
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
    sha256 cellar: :any,                 arm64_sonoma:   "c56ee61945abb31855e0c219709e716639fe9ca74fe382610cfe06fb3be58017"
    sha256 cellar: :any,                 arm64_ventura:  "8ca3f49dbbe33c36ce113a39d04c1fb542357c9d3dfd9a4f9a47b6afe7ecf28e"
    sha256 cellar: :any,                 arm64_monterey: "780a4154ef99f6cc9d00ad8cd5aa6674e1716c5344663f39c5efcf5e6a070cda"
    sha256 cellar: :any,                 sonoma:         "962429176616e5f686224e23a0a59f4b6867ec3f454ac0c0053f09e0835f0ed9"
    sha256 cellar: :any,                 ventura:        "a89ef4c6a536f6fac0b788bf4de7ece968c60c392fd73399ab01e5fb66aaa83a"
    sha256 cellar: :any,                 monterey:       "cb6e749e458a0f992c6e9bc6f1321d10118cc24ee15526a519fd963fadb117aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a82de834cf106eea7e55f688a40be370b0cfbd7ae3367d7e89337aa3a196728"
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
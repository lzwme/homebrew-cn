class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.1.1.tar.gz"
  sha256 "d882c4521a703dbe41ac1554604cd790a8c6d034a03cae531ff9bbd23375e405"
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
    sha256 cellar: :any,                 arm64_sonoma:   "fe3110800abf97bffb1105034b4ded58c45c0c31e6f871e9775bb58038501a4f"
    sha256 cellar: :any,                 arm64_ventura:  "e40df07c1c55d3b72cb595519f7b3a57f5933f67028a37e1a0bd0de04f89535a"
    sha256 cellar: :any,                 arm64_monterey: "5f25de5186663f4832a7b80a25ee0640acd9fcd513ce07a3114912e8580a535f"
    sha256 cellar: :any,                 sonoma:         "0d1ef0495e1d01778c792c04f133acfc1e2c8a84139ce79158e7a4461653fc30"
    sha256 cellar: :any,                 ventura:        "eb95f29dbbbc2e021edfa6c998f6a1de924bcdabf01e51d76e6b2486d331461c"
    sha256 cellar: :any,                 monterey:       "e632a431b88963ca48ffd7084ef250d08d6efac6d7daac3217fd4a0e53c3dd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec733a7b74adf34ca17ad9d1186b10ba280d93f3d71211d686d77ddc209c541"
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
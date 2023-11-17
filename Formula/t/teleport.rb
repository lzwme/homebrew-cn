class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.1.3.tar.gz"
  sha256 "c0e53d9fea8d771da67bd462145c7ba0a8d6b304632f455a75c72c861b2ba936"
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
    sha256 cellar: :any,                 arm64_sonoma:   "17632f10669073682c3d725c0bc3e859731d5ad0fa56a4ebc94284eab41d0c7d"
    sha256 cellar: :any,                 arm64_ventura:  "696653b780047c5e7335a91db29c397809d07b14ecb2fe51df41e48bb938da29"
    sha256 cellar: :any,                 arm64_monterey: "b81556d07a23456052029cff05cb6cfd129a749bf1710806d84f527c9512811f"
    sha256 cellar: :any,                 sonoma:         "51dfaac3b5007579020846feb2705959139da6f53b78900dded4e853c54b0f44"
    sha256 cellar: :any,                 ventura:        "df60773a14bbb3c68901313a63c727b75e38d09f0d0f5b678f6105289fdc1046"
    sha256 cellar: :any,                 monterey:       "ee4e16f4428ecdafab24a995b66c49bfa333c4af62daae818c0abce6946181bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17374be3f7670e625504b2735bfcf1ac1c76999ad05c1c9ffa2a1849a1756d88"
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
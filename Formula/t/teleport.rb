class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv14.2.3.tar.gz"
  sha256 "31e080a6c7e8740b7a0fd2be355353f99d2a790ea8151d3f7a0ce1c379655af9"
  license "AGPL-3.0-or-later"
  head "https:github.comgravitationalteleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4904e6284748a1371d206d4ea0de3817b54bfd3eb283ae8efa86b39da2c42425"
    sha256 cellar: :any,                 arm64_ventura:  "0311130097e127c8d5812ea5c916b8386330a5e112763dd68b72917a9d25bfa6"
    sha256 cellar: :any,                 arm64_monterey: "c823292a96c8a6a5328a5e8940fac357e680bdccd7358299bd4bab8d8924fa1b"
    sha256 cellar: :any,                 sonoma:         "f0fbe9693a68331952295a65c00f6a94578e1c29c8735c34bde0e1ece780b8e2"
    sha256 cellar: :any,                 ventura:        "5a56ce3cb5a137c22060feb91e72d849542de1c96b55854be08b23e865d73314"
    sha256 cellar: :any,                 monterey:       "154e8efca86a6731844bbf55fdd9ad442aaf3f80a784c4d1fef5f6bb8ceab180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2052ace0dca72a9c6f8c787c61cf1f1b78d600f6a5ac2ff92ae8963aeb55b793"
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
    bin.install Dir["build*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}teleport version")
    assert_match version.to_s, shell_output("#{bin}tsh version")
    assert_match version.to_s, shell_output("#{bin}tctl version")

    mkdir testpath"data"
    (testpath"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}teleport start --roles=proxy,node,auth --config=#{testpath}config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https:localhost:3080"

    status = shell_output("#{bin}tctl --config=#{testpath}config.yml status")
    assert_match(Cluster\s*testhost, status)
    assert_match(Version\s*#{version}, status)
  end
end
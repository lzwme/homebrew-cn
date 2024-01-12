class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv14.3.1.tar.gz"
  sha256 "0bcfc608983a40289ee5db777f4fee0e5d4df8c9b2799eeadf3c4b762a0eee1e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "42b87f9b68577ff165e77c8a00b779ece646dc3a6749f88378e80fdc659de818"
    sha256 cellar: :any,                 arm64_ventura:  "595dc5f28983ca42fa6387064c3f554e028bf217f649da3bc0c85507d2605cef"
    sha256 cellar: :any,                 arm64_monterey: "928268350e7c4d0efc3f653b90424f9c716a948a756e5f70da6c761c589cda5e"
    sha256 cellar: :any,                 sonoma:         "bb8c0f5e754f74c945c87dbcb5ae60fc952c3a51dab6c32a70b992b55616e4de"
    sha256 cellar: :any,                 ventura:        "adeec736cf716cf37bc0f12045bef9bc9c0a4913c93e8429f9bc4eceeda0bed2"
    sha256 cellar: :any,                 monterey:       "e25d93c3d24c13bbce9c01dc2dd549a668918df3e14f2765eeeb0ac946d92495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30cd2f5dd58ae586cab42328cad21243eb05aee78f8f16d8192783927970224"
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
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.3.1.tar.gz"
  sha256 "93d993e63981da1146b9045b2dcc05239db4b08cfaf2faa31eb15110d2bef5aa"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e22ecf50cb5c6b65c548e3e224242982d30534c2dc715009d447f24b2e49682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369ecb2ed1ed870bfd13bcaa82be385854189cebd831e17fad1aa0589f2b5c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85596c0a0d68d4ca16e56f1f87ab9a51b0650fa66fa4214cdef209810e936dc"
    sha256 cellar: :any_skip_relocation, ventura:        "e99a4f79b6aeca58d2445e5c70d3aacd4c612d006d6133a80af07da0347b04ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c4cce146f6192837395dea3b57b22db7ed1d3bd9b184a06bf52e4a451dbd1cff"
    sha256 cellar: :any_skip_relocation, big_sur:        "c874f90601f36ac75408aac675ed775ff3b0ac08cde15cfa1a4d998296b2b2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa127583d6d35755c4b8be276dcd6061beb45536029ce582445650d2e0d0de8d"
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
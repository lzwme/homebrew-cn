class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.2.5.tar.gz"
  sha256 "fbebeb15a6e4af6fcf1f71d667d85e576fe238c57502b5a3c7c036c40180f570"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b44f1b84f4dc753a5d3aceace32a8866f115909751c683d19f0bad4ed1d1e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73eec662792387ffa7c6e37f23100a5aec2165b0a1dd51dd4d138ba24f8d935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590c7426142a660c9551e43b9375181497ad7ec111860ad4470b35ab9367ed4a"
    sha256 cellar: :any_skip_relocation, ventura:        "207cd7a6a22c3c8f6a7434dcf4e476c4679f3f2434e76aaa1e051f1bb69af039"
    sha256 cellar: :any_skip_relocation, monterey:       "45e94c76e8062e9767d0c272d04b41228629709dbc36a49600dd41ea604585ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8311bb9d73bdbc742a0798471b4a1643a534deb47b09728e44bd802b6111404b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6109848ce21a6be493de3cdfdb5a297ea8c929186fb6e145965982d2a130be82"
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
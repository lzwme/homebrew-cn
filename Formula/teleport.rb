class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.2.2.tar.gz"
  sha256 "de8c32d595921dd9f955ed2e9d66edb31eb9c8f8618188c3be9c57933009fcd4"
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
    sha256 cellar: :any,                 arm64_ventura:  "a494ca338a5009633bd032b1dc60f6c8f77b6548fb73c949b70f434a8620c6fc"
    sha256 cellar: :any,                 arm64_monterey: "dea984500885443b119442211f6c1d2a07ea926ee30fb45354f045bd868bca43"
    sha256 cellar: :any,                 arm64_big_sur:  "eb3666f2e41e98b55fa29e8749da57edd079fb3dd5eb111d8db2e8bbe8f6d31c"
    sha256 cellar: :any,                 ventura:        "aceb7df8b5a2e938034841c9d0e56a168c3c48ccabc321a9947bc0c21d36b92d"
    sha256 cellar: :any,                 monterey:       "588a0899a89da7a22e0f6ac5e067574433ca4538a38bf04af76bf08179a343a8"
    sha256 cellar: :any,                 big_sur:        "f956b315524cac86e93bbf89882fe56b5df6f8be8a2d5ecb41ea66f09d26be74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "412cefbd6cbe8207afd14dc62fbbc3658c4d31a76c5acd0cbd6ee25b83165918"
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
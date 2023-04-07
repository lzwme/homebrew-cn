class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.2.1.tar.gz"
  sha256 "ba53679c08ce3d63bcf3ffe384a862ea6774996d36b6bf3fbe88257ce4555765"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8937c9e2ed88d6dab9be53b1629b114052f88629d23a6a324da5d1faf9203f2e"
    sha256 cellar: :any,                 arm64_monterey: "1ba47e9fa78e021c605a01fbf9feb32dccd43858e751ca6201f5ff669b3def36"
    sha256 cellar: :any,                 arm64_big_sur:  "6cf88e2890490746c4dd340e5e61727d703d6bf35b483531eaa9b5ae1ffefe5f"
    sha256 cellar: :any,                 ventura:        "3ca243941bb0a91c9513f6a8c52369d98424413b38f84b6e3731bdce0c0ca1d4"
    sha256 cellar: :any,                 monterey:       "a8763364c019fba86c1e3ee7b9367e4f4976bbcf11ee8d343edd8c068c30d9ee"
    sha256 cellar: :any,                 big_sur:        "4e0d6d4eef2e4cd5a7bf10489f0690c1f574e6b2220b654e2f3b833ba6344ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c49727206d7d65cadbe73ba6d44884ea22f0d7e11205ec7fc862b58e10db9c3"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

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
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v13.3.8.tar.gz"
  sha256 "1eb2471c144c480abe7effa0e90e921e050ab6964f06ab51381f22c119871967"
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
    sha256 cellar: :any,                 arm64_ventura:  "799b9a5b274f6c32ba3715bf2aeb01b65dd4e211028c6af8444ff01e5830a1a8"
    sha256 cellar: :any,                 arm64_monterey: "217dd7a482c84c728d531767dad48416c60c9d3ed3a290940a62243ea577ada6"
    sha256 cellar: :any,                 arm64_big_sur:  "20f25b9b905f4e258aafc8e7e986cdb56bf4a068f41ee68f674159290a92f081"
    sha256 cellar: :any,                 ventura:        "fcd5f9e7dca700791bd68064d251d03c03ece98a60a6f9568d18b1929dff21c5"
    sha256 cellar: :any,                 monterey:       "1e2da7c58e5eeb4b88d849fbdd9bd6ebc3363c787fb5251ddfd6a62c525d45d1"
    sha256 cellar: :any,                 big_sur:        "0e485bfc397c3327911ea6bf86f81483c95d0023cd926646d96ea57bda24cafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9a0de555989c1fa2eebdad24ed0285f11f326b04c5836fed9d510b6f4586f2"
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
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.2.2.tar.gz"
  sha256 "0ad348bc4724f39f7f6272b8bd4e211af3f0367bd79bf33b0571abd925914ee4"
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
    sha256 cellar: :any,                 arm64_ventura:  "0ec1f7034e1153af809ad98b63a1ab4f8ef6c8671e8d626c9be7d8dc7146d23a"
    sha256 cellar: :any,                 arm64_monterey: "26caf1b3b8750f2582e66951243a17c347d986cfb50baa92a1e313a108190ea5"
    sha256 cellar: :any,                 arm64_big_sur:  "af70a61e81513bc1b9c67b69ce4b54667532445c788155010d6e0706519a3b78"
    sha256 cellar: :any,                 ventura:        "ddcef49937cc09825d47d4f73d3483df40861375b82f9d7d4c701d4489ab01f3"
    sha256 cellar: :any,                 monterey:       "a27619a61adc5ad09e8a5318c02b2983f37a835dfb770749bd1f481b2513ee2f"
    sha256 cellar: :any,                 big_sur:        "d1ff72f7a0fa7b6167ae80d8d4440b104b7f83fba0ddff376ed6d97322b647b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb0632b3d7f9afb2249bcab7e39d4dc967d01b6dd52bddd0eb094ff29a1573a"
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
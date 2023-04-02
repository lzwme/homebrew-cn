class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.1.5.tar.gz"
  sha256 "b20f95990bcf9a4bd15a27366d920ec0cde4c18a4fb44ead2833ecd1863a8b8d"
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
    sha256 cellar: :any,                 arm64_ventura:  "f3143a6569b9764e8cbf3db7ebe0e0554f450729c5a2583fce245f3baf355774"
    sha256 cellar: :any,                 arm64_monterey: "2d4aa4012c0f22570d8dd2a034db472bd00e0258da2f9610898b543f859ea910"
    sha256 cellar: :any,                 arm64_big_sur:  "ce1e720e32c48b108f9b8e53a3db02bb6e1ba53051b057b0f098c59ce6feae72"
    sha256 cellar: :any,                 ventura:        "87fa0895226563f6ade4b5084e0dcec6f8a29582cf923bda7d03c479fa503dbd"
    sha256 cellar: :any,                 monterey:       "b9ad360e9590ac6cfd1ebad0e413d5598d93812608f426a0562a286fd6326c0e"
    sha256 cellar: :any,                 big_sur:        "594f8e2cc971bf90ba550b03dfb0b3d00a204fc6aa8111bd9a798275c2150923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e7c5d50ac005a3beee40d76bf09c3c095fee42a0cd6859a33f1efabf72d1a16"
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
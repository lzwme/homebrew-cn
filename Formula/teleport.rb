class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.2.5.tar.gz"
  sha256 "9dc41cf6ed6436829f147abfd939e53906e07334ceef497eae50320decdfa8d1"
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
    sha256 cellar: :any,                 arm64_ventura:  "6d32c50997f40049090ad32d959bbe4829b80a238bbc29d6919d07780f0830ac"
    sha256 cellar: :any,                 arm64_monterey: "34ee1e7d85c6fe0d0056a7617675b89d083e47cd97ae0d4ba8ea456f4420307a"
    sha256 cellar: :any,                 arm64_big_sur:  "b3e16b124031aa36465183d5da55eaceabab35145d4ea716d8db97a5ef8673c3"
    sha256 cellar: :any,                 ventura:        "17d2d2024be6e26f200bfac56b0787ec2c478a4141a55584ca01b9df1c6ee592"
    sha256 cellar: :any,                 monterey:       "bf142105d6ecd1fd45533ab03cd886747ef6dd6c88183b4230cc07f66685bcb7"
    sha256 cellar: :any,                 big_sur:        "9c02f2a3420564078e3fad83ebf0bf28efff3074790511bf22f764e72833cbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33447a8363c643ba6c34677d78b7ae3788998ece136e78cd550f5cc22bd02775"
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
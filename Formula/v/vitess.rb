class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://ghfast.top/https://github.com/vitessio/vitess/archive/refs/tags/v23.0.1.tar.gz"
  sha256 "2ee250d371817f72e89f1c2e87044a84624a5f219a8e61a13ebcdd7e1c4cbd6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cdd2d26a5dd1554448bbae8de3be8a84e1909da87923494e0cd114b1811e2ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5bd46b72c64f0ff8f014e2a9001f93e4bbf25fe95771931b24514a3f5d3294a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b7ef4d7593693d78e9bfc8aebae852147b25776c58401e9e558d7be1f859ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5c798678517df3dcf13be10153a63f6602d120e6b577fe40dfa6759bf4315c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a388b39e5816af5ec1ded3cbc3d75c8db2488ee5ad89908c4a202cd14216743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5b896fff3facad19567ca3c215667309002d2d32ed80a8ae191d26fbcfea33"
  end

  depends_on "go" => :build
  depends_on "etcd"

  # Support Go 1.26 and later with Swiss maps always enabled
  # Upstream PR ref: https://github.com/vitessio/vitess/pull/19088
  patch do
    url "https://github.com/vitessio/vitess/commit/1e131ea41b87a047acff3b1977d9fece8e25bfff.patch?full_index=1"
    sha256 "6dd13ffbde947a2c0d426c5a6361e3f0f708c9fc1bd1df7b000ad06fa8644a9c"
  end

  def install
    # -buildvcs=false needed for build to succeed on Go 1.18.
    # It can be removed when this is no longer the case.
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}", "VT_EXTRA_BUILD_FLAGS=-buildvcs=false"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "3"
    etcd_server = "localhost:#{free_port}"
    peer_port = free_port
    cell = "testcell"

    spawn Formula["etcd"].opt_bin/"etcd",
          "--name=vitess_test",
          "--data-dir=#{testpath}/etcd",
          "--listen-client-urls=http://#{etcd_server}",
          "--advertise-client-urls=http://#{etcd_server}",
          "--listen-peer-urls=http://localhost:#{peer_port}",
          "--initial-advertise-peer-urls=http://localhost:#{peer_port}",
          "--initial-cluster=vitess_test=http://localhost:#{peer_port}",
          "--auto-compaction-retention=1"

    sleep 3

    # Test etcd is responding before continuing
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/#{cell}", ""

    # Run vtctl with etcd2 implementation but using etcd v3 API
    spawn bin/"vtctl", "--topo_implementation", "etcd2",
                       "--topo_global_server_address", etcd_server,
                       "--topo_global_root", testpath/"global",
                       "VtctldCommand", "AddCellInfo",
                       "--root", testpath/cell,
                       "--server-address", etcd_server,
                       cell
    sleep 1

    port = free_port
    spawn bin/"vtgate", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "--tablet_types_to_wait", "PRIMARY,REPLICA",
                        "--cell", cell,
                        "--cells_to_watch", cell,
                        "--port", port.to_s
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
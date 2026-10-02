class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://ghfast.top/https://github.com/vitessio/vitess/archive/refs/tags/v24.0.4.tar.gz"
  sha256 "9fe12433a64542af7c9e1799102b8c7707d3f197ee3be737a1ef0e2d5e8e5c93"
  license "Apache-2.0"
  head "https://github.com/vitessio/vitess.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97ba0c0a694ca53657202c51fd55101fe9ac80919165ff7337e5372822076897"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97ba0c0a694ca53657202c51fd55101fe9ac80919165ff7337e5372822076897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60465dda78d675dbcf69d1baa669fc9360ed475a114227b8a7545b9587e050aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73d5b84baa47fd0ea982c99b614d6ff0b1fe8cc06c872f906565f9d84c2417d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73bd12eccadf98149b1130e73c0f72e470d8afbbd6f83114ee8c8ba6c0b47e07"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    ENV["CGO_ENABLED"] = "0"
    bin.mkpath
    ldflags = %W[
      -X vitess.io/vitess/go/vt/servenv.buildUser=#{tap.user}
      -X "vitess.io/vitess/go/vt/servenv.buildTime=#{time.strftime("%a %b %e %H:%M:%S %Z %Y")}"
    ]
    system "go", "build", *std_go_args(ldflags:), "-o", bin, "./go/cmd/..."
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtctl --version")

    ENV["ETCDCTL_API"] = "3"
    etcd_server = "localhost:#{free_port}"
    peer_port = free_port
    cell = "testcell"

    spawn formula_opt_bin("etcd")/"etcd",
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
    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}",
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
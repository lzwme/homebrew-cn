class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://ghfast.top/https://github.com/vitessio/vitess/archive/refs/tags/v24.0.0.tar.gz"
  sha256 "dc7d6b8835249550fc0ff0d77b4f5ef5e9842d9656860ad9d8340201655d8cad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebca25be84fc314fa46402516536a78597825e860d86d68bccc2dbed31ce3de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4e495201d38bf0113cb1d5084eeb469b5ae946cd2fa9e5d45d5aceb28b02b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f772cdd8170ca6f0f2d814eee9897cb2566d76fc81f5a1c426789f7387b016c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa132faeae4ef203f10eda57caabd4648e7e8eb00535f9aa0e75291452ad8faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d300a77e86c6a695e6048be426cf6a58fdc54da1094212bbbc0333b73703553e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03b40196f0115cc88dd5e3e1ff8ae7c65baf5955be257077fdc5020ac5786d5"
  end

  depends_on "go" => :build
  depends_on "etcd"

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
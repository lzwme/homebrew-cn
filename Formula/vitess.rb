class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://ghproxy.com/https://github.com/vitessio/vitess/archive/v17.0.1.tar.gz"
  sha256 "0bbd34afdf0997a1707a4e5a66edabd9624537386d829387fedf0e464eb71f69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d169e8d8d13fe687b129d2b543113dca2bb5e91784db22e99255e902591085c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7fc14cdfc0484d7f9c032a5ed4a537e7e620c8729ee52f083704b2ffb8ce731"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a796c0e0748f768bbfa0323d6fbde32ebcc736312836c6e6098e5595d97e7f65"
    sha256 cellar: :any_skip_relocation, ventura:        "296be95e9e8a3e7b6f9bd07599c991c90db2d4c62bf4c088b7d687c7c2e998cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d11885ab00384b88c73f612276385e262c04a1b361060c40a21259bc3c49dec2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2df776bb0b19c68b9bec9e61a552debe7bc74f0c41a1111d8646354bbbbfc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49e44a38e3c778f3245a00e4653be5ad5674c1596d7d08372c4b91e7aa7f549"
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
    ENV["ETCDCTL_API"] = "2"
    etcd_server = "localhost:#{free_port}"
    cell = "testcell"

    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/cell
    end
    sleep 1

    fork do
      exec bin/"vtctl", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "--topo_implementation", "etcd2",
                         "--topo_global_server_address", etcd_server,
                         "--topo_global_root", testpath/"global",
                         "--tablet_types_to_wait", "PRIMARY,REPLICA",
                         "--cell", cell,
                         "--cells_to_watch", cell,
                         "--port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
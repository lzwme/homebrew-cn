class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://ghproxy.com/https://github.com/vitessio/vitess/archive/refs/tags/v18.0.0.tar.gz"
  sha256 "9d5b9de23ec69ef61a6a727781dfa863eb84111566066048c2b243de68c0804a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60cdd43d53298a821dbd96bc29ceb05d3ff91677f4559db9af7603c08367097d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8be009c6e7e1ff1ce6a2f92cc78580f925a1790b409c48fb67f63edb13a69f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c50d9d6af5490474577d38e5a128f37c4adad003907ac638a38af6f736f9c9ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "94ccfa7cbc5454474e52b28823e03b30b0a23bfdbeaecb0442b723962a901355"
    sha256 cellar: :any_skip_relocation, ventura:        "49201d31737a9894d5641b02287edcc1061dc32a77d1fd2cfc2b3dfddafa2f6e"
    sha256 cellar: :any_skip_relocation, monterey:       "78bbdb3ae5184fed5432588fd112c75bcc3ab54d7414f74241afe357a906ece2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e0bac559aab9a3b1280a42f954182e0e3f54673de1ca0a05f0d424e3d84b2e"
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
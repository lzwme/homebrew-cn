class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https:vitess.io"
  url "https:github.comvitessiovitessarchiverefstagsv21.0.3.tar.gz"
  sha256 "f266669099c2908df0d2b6677ebe220fe0126dad246a1347d68ce736144d211d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd3f3473be52b5ebba795e57a76ec9931e3c74337bf77e1edf5e4ed74498efdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6a98d76e410ab6122bc9871c60d2d291a8222f942ca933e1c511cfd4f8ed20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddac46e0bf22e3a1f93fc45b8bf2e51ab38dfa5772c0ecd3d2f365fc95e911a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0f1415489d991a6905a5c8e222fb6c4b4ae1a7475c3f5fdfb1d69c52ae2c66b"
    sha256 cellar: :any_skip_relocation, ventura:       "0b0fa781ff71837937469ccad3fef2767271be9a0a62b866975d5ca110c4b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ea80b9ea162b20ff43aba5ac5d020058f96fd5e2b691a485e2f42e6d488409"
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
      exec Formula["etcd"].opt_bin"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}etcd",
                                           "--listen-client-urls=http:#{etcd_server}",
                                           "--advertise-client-urls=http:#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin"etcdctl", "--endpoints", "http:#{etcd_server}",
                                    "mkdir", testpath"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin"etcdctl", "--endpoints", "http:#{etcd_server}",
                                    "mkdir", testpathcell
    end
    sleep 1

    fork do
      exec bin"vtctl", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpathcell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin"vtgate", "--topo_implementation", "etcd2",
                         "--topo_global_server_address", etcd_server,
                         "--topo_global_root", testpath"global",
                         "--tablet_types_to_wait", "PRIMARY,REPLICA",
                         "--cell", cell,
                         "--cells_to_watch", cell,
                         "--port", port.to_s
    end
    sleep 8

    output = shell_output("curl -s localhost:#{port}debughealth")
    assert_equal "ok", output
  end
end
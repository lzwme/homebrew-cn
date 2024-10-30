class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https:vitess.io"
  url "https:github.comvitessiovitessarchiverefstagsv21.0.0.tar.gz"
  sha256 "a7c5c0391b2461fd78e3fee3362ca2473153d8e0b9c5bddf2c1cc066c2e29d3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4e19bd93f6189793480eae223553ad6ec8b1b5f1b29521714db8115b3f3776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1b81a58cbd9663f1df39b32af1b23c9672b1db9ff1193909177985f85db542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19f2bf9bf62e846dd6748da2e40a94d07d6e840f13aab1ba50ec8cff0f4ab73f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7db58b223cac831550d683dd0f5830af901ee5a104bcc3ffca22d34a7e3c5e"
    sha256 cellar: :any_skip_relocation, ventura:       "fd5274b11fce55904fe988861711534cb77ff1346e4e11083672742b66dae574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d6b40a774930e3d01e5e86625f353b8c4d425af6fd54dc7b5d3288b5d5a4ef"
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
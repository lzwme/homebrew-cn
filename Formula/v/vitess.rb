class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https:vitess.io"
  url "https:github.comvitessiovitessarchiverefstagsv18.0.1.tar.gz"
  sha256 "bcd2392efbf63f2a4fc59699c257877b1cbb636fd6d964ed2b735237121e7795"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db9c2a21a39038ec969f489336dd55001d99df0558edc87982c1ffa1989cd316"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9155a82601525ec8831a976bbe266345bef0244e333c1329b00f21f0232a1682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b748d1c9b624e413c01e30f753e180c6cc7eff73243ad4afe68681d70789d623"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4ce1dcbae992b0553a54e3cb7745e232247982ea1c0fcda006a35bde97b833"
    sha256 cellar: :any_skip_relocation, ventura:        "67bff82324f25ef7fc7cf601f748d71c64d9c00068f48ced8857af87276f147f"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fd3ff3aa42ecdc20108dccf500d5904e2d4592632d71ea3c5fa5fd8b334d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e691476ec5f88181dadc173208def08c387431fa9ab20ca5029644d32012eff5"
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
    sleep 3

    output = shell_output("curl -s localhost:#{port}debughealth")
    assert_equal "ok", output
  end
end
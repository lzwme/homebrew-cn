class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https:vitess.io"
  url "https:github.comvitessiovitessarchiverefstagsv20.0.0.tar.gz"
  sha256 "b59a5fb4a865c195e21f9d1f56306e6fb32b02dd9aa71752e9c690bc8dd37ab6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5233bca9cd51f452b12dedcab569ebdf3f719c22982f94368119df3c3a0138a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49035c314d823719dc87f7b467d1460192c2741b3d89c349e92e024a8dcf626c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135584e53ef71c561a35cd3d43c60a06c576ba454df6a002c1a40bba16403322"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae04b763d2264e1583f776488d25da22cdc5c3b0e0a8e2b14ab8bd128fab7091"
    sha256 cellar: :any_skip_relocation, ventura:        "8c596f72ec03b8d211ca8f5adb6551eaf5bc1326bc692f6a915ae72a343c7d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "71544b2661fd1dff8ea87e4059e58835e8c703f93d0bc49c900232a183f1e929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6395da5655292083dd3bb1e2b40936c18f5133cbe3241ca5300ee3b0e2ac1acc"
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
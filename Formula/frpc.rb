class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.2",
      revision: "7c8cbeb250e03b806759b66ca94fd1bf280d3d7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81f7cd6c334aad4bd57fd18a369f95c81b1d9eedd0c4ba6bfc3c47127e22d275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81f7cd6c334aad4bd57fd18a369f95c81b1d9eedd0c4ba6bfc3c47127e22d275"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81f7cd6c334aad4bd57fd18a369f95c81b1d9eedd0c4ba6bfc3c47127e22d275"
    sha256 cellar: :any_skip_relocation, ventura:        "f8628dfcca7ab41f606ef77603f4b1b06780c005a512f9a80eb821de5c6995f5"
    sha256 cellar: :any_skip_relocation, monterey:       "f8628dfcca7ab41f606ef77603f4b1b06780c005a512f9a80eb821de5c6995f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8628dfcca7ab41f606ef77603f4b1b06780c005a512f9a80eb821de5c6995f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815bbd9b1f7a6f7c43c704a7141bd98a7940712215167859e9e25d2a9dba4aa6"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.ini" => "frp/frpc.ini"
    etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.ini"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "local_port", shell_output("#{bin}/frpc http", 1)
    assert_match "local_port", shell_output("#{bin}/frpc https", 1)
    assert_match "local_port", shell_output("#{bin}/frpc stcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc tcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc udp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc xtcp", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc status -c #{etc}/frp/frpc.ini", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc reload -c #{etc}/frp/frpc.ini", 1)
  end
end
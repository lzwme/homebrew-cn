class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.1",
      revision: "4fd630157703590e677728d20348ac6a2dfd9151"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6fb731e736408941565bd89462ccc9ac5a06d53a037ab17782d66cae65b8e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6fb731e736408941565bd89462ccc9ac5a06d53a037ab17782d66cae65b8e0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6fb731e736408941565bd89462ccc9ac5a06d53a037ab17782d66cae65b8e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c8ad3104cdfe20dc5d7b15c707bc496c613e894eca1299fd90160eec41e0e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c8ad3104cdfe20dc5d7b15c707bc496c613e894eca1299fd90160eec41e0e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8c8ad3104cdfe20dc5d7b15c707bc496c613e894eca1299fd90160eec41e0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7d7c39867e38186f763e06095fbdeea9c3c00c90cb18b1ac1d23b534bbd902"
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
class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.0",
      revision: "53626b370ce2be290e844e58a1384af5059ea489"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5750ceb4ba9331c08670a7b7cf142d3eaa9eeb938b9eef35f8c8b62b292c894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5750ceb4ba9331c08670a7b7cf142d3eaa9eeb938b9eef35f8c8b62b292c894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5750ceb4ba9331c08670a7b7cf142d3eaa9eeb938b9eef35f8c8b62b292c894"
    sha256 cellar: :any_skip_relocation, ventura:        "d0079601e68ecd94f238afc21c0b4434ea8a64f4b75341304fd44b475657e469"
    sha256 cellar: :any_skip_relocation, monterey:       "d0079601e68ecd94f238afc21c0b4434ea8a64f4b75341304fd44b475657e469"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0079601e68ecd94f238afc21c0b4434ea8a64f4b75341304fd44b475657e469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d511a9749c4c41ac5dd6fe34eda2a9454367906a43728961d33a07145e92ab"
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
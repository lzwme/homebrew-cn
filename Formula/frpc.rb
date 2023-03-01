class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.47.0",
      revision: "88e74ff24d7f2cbbae536904fe00324b195a278d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ccdbcf6cf59ed5fe6ac0aa620629ca9d1e38ed74ad551c985a5214d8f5b6e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75a883f55a5b855063d2f53618f67cee3e46feff7bc63a9e83d0e8f8347f019d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eccc3071582d897427f46e556857283a22ce0eab8da5aef8b45bebe1c3be3287"
    sha256 cellar: :any_skip_relocation, ventura:        "d6937a57a93094b225807890f488e877494a9e3e5f5fa030ffba9663d2a71ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "b5655311584e9fadc0c34659d0ae6996add41a81b0bc317670d2f274d3882620"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9fd86a4c8dd66ee32c7bd612d2181e8be874daac25afedcb6d423fd02ab058f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a186c43bcb5deb81e76c0679c311b4e52ccfc8bcd3a804dccc17296887a716"
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
class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.53.0",
      revision: "051299ec25638895e36779c305abf554671b4f68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75d8fa848b12da58e054b595ad839704bd81a59b6a49f3ef63603f9a2727aef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d8fa848b12da58e054b595ad839704bd81a59b6a49f3ef63603f9a2727aef8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2f00bdcb5d3ca8dbb99c93c8d7e167f4a86f9fb38428a8404ffbda0b6a4a2cd"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f00bdcb5d3ca8dbb99c93c8d7e167f4a86f9fb38428a8404ffbda0b6a4a2cd"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f00bdcb5d3ca8dbb99c93c8d7e167f4a86f9fb38428a8404ffbda0b6a4a2cd"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
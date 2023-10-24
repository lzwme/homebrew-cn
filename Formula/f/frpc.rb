class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.2",
      revision: "c9ca9353cfbb377e128af6af725ab24167dfae5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6931aee2384708f62a71ea734da6c6a7649c2b468536a5e71c834ab7aa499457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6931aee2384708f62a71ea734da6c6a7649c2b468536a5e71c834ab7aa499457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6931aee2384708f62a71ea734da6c6a7649c2b468536a5e71c834ab7aa499457"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99c730726b252a0fecac5cec9fe04cdc952bea5c6b4e55b71c5a16b5794e005"
    sha256 cellar: :any_skip_relocation, ventura:        "c99c730726b252a0fecac5cec9fe04cdc952bea5c6b4e55b71c5a16b5794e005"
    sha256 cellar: :any_skip_relocation, monterey:       "c99c730726b252a0fecac5cec9fe04cdc952bea5c6b4e55b71c5a16b5794e005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f849c0d1779f7b290fc7adc7d6f9ffd6698e07e60c108f95c88484ea67a975"
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
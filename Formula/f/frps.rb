class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.2",
      revision: "c9ca9353cfbb377e128af6af725ab24167dfae5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1067b2ff525c0a18b04fda6c972a0c346f3d546d17939dce3024f67690bd1d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1067b2ff525c0a18b04fda6c972a0c346f3d546d17939dce3024f67690bd1d97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1067b2ff525c0a18b04fda6c972a0c346f3d546d17939dce3024f67690bd1d97"
    sha256 cellar: :any_skip_relocation, sonoma:         "5870c660b32878dd51bd55de9d6f8a79f21fd924a67bc7b69789d0ef5ac0a52a"
    sha256 cellar: :any_skip_relocation, ventura:        "5870c660b32878dd51bd55de9d6f8a79f21fd924a67bc7b69789d0ef5ac0a52a"
    sha256 cellar: :any_skip_relocation, monterey:       "5870c660b32878dd51bd55de9d6f8a79f21fd924a67bc7b69789d0ef5ac0a52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56f85c86dc64b90fc0a782cadf80100f6afe25806cabdacab6f688ab9900bfe"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.toml" => "frp/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
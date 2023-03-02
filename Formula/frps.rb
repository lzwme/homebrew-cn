class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.47.0",
      revision: "88e74ff24d7f2cbbae536904fe00324b195a278d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3387931f7d738bc94b8295c0eea1fb5a018dbc4ca0ab50f77f999f982f559152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c981b6546ae1d28f71a84955738d794cdf2f441a97f45370515ef34557f9a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e76f0905b2ccfef2844285944735ed95fa73037f6f792d9f86ff23703888a30"
    sha256 cellar: :any_skip_relocation, ventura:        "5dcb4d7b3fbdb50f339fd2080db93661ec7e19fb3b99c07a11c1cff8ee90a72a"
    sha256 cellar: :any_skip_relocation, monterey:       "c28b6b3824e0cf00f6e251473b24936b39475ac18d1189b60d87e7b96e27454f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8431075f076398401b98546357e0ce38f1124629ffd2d376f8f2cf4a34f23eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58ef15373fcb57b6f253aeb5c93a5c544b57b2c99d3c58de482428b69a5ff57"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
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
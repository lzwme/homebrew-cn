class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240705.tar.gz"
  sha256 "225e294ed2715be33e23c9e407b851bfd01dacb839fb0cc89ef84f3cdfb82e62"
  license "MIT"
  head "https:github.comxtacikcptun.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)*)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a37093cacbafa52de796ab875bde9335eb2ecf84fc6d6907e1b354ecff04aba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ec079cd4386720e8e55ea94c837516cc8ace5ff09035df122fe073b582dbc0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17cc4039f8f185ad30f0af6c2191f5b6219347277f8bd3933aeb8a5a6920f0fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "9df2e753814e8ef295f611554a5fe4833d612353c177e9bab71acda540089908"
    sha256 cellar: :any_skip_relocation, ventura:        "476e04a2b97dd5f51ac1086d004e9e777e8b2a67290a0c348ae60a37968166e5"
    sha256 cellar: :any_skip_relocation, monterey:       "9a6e6f5d55d2a1b7df3a7ea3ecbf5ffe17034f6690a139541c47695fc6edddb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c600bef5cca43e848179de0f6816ecdf42a57f5a996531074a4e0ccc409d8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_client"), ".client"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_server"), ".server"

    etc.install "exampleslocal.json" => "kcptun_client.json"
  end

  service do
    run [opt_bin"kcptun_client", "-c", etc"kcptun_client.json"]
    keep_alive true
    log_path var"logkcptun.log"
    error_log_path var"logkcptun.log"
  end

  test do
    server = fork { exec bin"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http:127.0.0.1:12948")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
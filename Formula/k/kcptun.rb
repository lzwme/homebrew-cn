class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240701.tar.gz"
  sha256 "8282d29c1b2d2a1c69bfed3405a623d4ed5b44ab05acbfa972d07622518c1c0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e32796258db100c4cf70f3b9dd5ae5c00db1dbe4a2a4145378774cbc8e88729e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a675a33c826a012b7f166a2c9dff8e7e894ed2dff6fa30a6e9cc82b322ca834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754e237d2264d35c2355cf90b387a5f66296cc54fbb8b04cb8ccfd69a339cc7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c42a3b6bd9b14088783d45463d54ffd0d58912bf1357a2b496800fb9639ea610"
    sha256 cellar: :any_skip_relocation, ventura:        "0c78b10b19127160df1b338a9c4eb127bb7a6fa2938ca09618203dc1d944ecdf"
    sha256 cellar: :any_skip_relocation, monterey:       "db6476c411aaa819b4d7be078bf4e37542a72968be8e632aa496ca7e6d64fcbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705a1cebb8c5ee856f2a51956c40cabdadc4221dfa9247b1d609a6575f744468"
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
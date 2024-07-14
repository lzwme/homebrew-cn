class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240713.tar.gz"
  sha256 "d9c00ac7f1523cec2fb7f0950429e3cc50f1b7b798931b1f6e4f52c5e347dec0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff4d6a6ec2d8a41d856152c2e7962f21f79c30efd7d4217a21e4ba2ed30d191"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20f890f7503cddfca3feb13ae3bad98db9654453a683fb4f13e0d8a47b1adc85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a80d4d4c70a4d18c703843204e8a741c2f197481eeb719a57e1e1ae9d7f306d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef1bec449e0dc0e8c22a79971d2e107efbfba64d24c012a032c907c39a1e903f"
    sha256 cellar: :any_skip_relocation, ventura:        "7b50f88d18e7e8bf2666de9319a1bf932b4b932190d970266b3d30c12bd2c83a"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c9ad5b7f8dba53a1732ba7e0736aeaaa8aff2a8c82734d994079904dfc968d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b52a518259d955c87b834c50873f2dbedabe4bcba436efecfcca0533142aa18"
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
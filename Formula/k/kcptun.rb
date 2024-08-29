class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240828.tar.gz"
  sha256 "a20523d2a54aa7782c901733689278a6ddc2a0a2e78ecdcdb21e7184d4eab4ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0833de090eb175a37bb48f9a08ee8bdd64efbf8646c2d34001cb454259440ec7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0833de090eb175a37bb48f9a08ee8bdd64efbf8646c2d34001cb454259440ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0833de090eb175a37bb48f9a08ee8bdd64efbf8646c2d34001cb454259440ec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1532bffc14e9694b0a31e382e40662c39b32c4fe9880c97efc1c0bc6dabe3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "a1532bffc14e9694b0a31e382e40662c39b32c4fe9880c97efc1c0bc6dabe3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1532bffc14e9694b0a31e382e40662c39b32c4fe9880c97efc1c0bc6dabe3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f59fefd820759d4b6f39622a1f65b94cce284b97f0b7b51a248f5f513e594e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_client"), ".client"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_server"), ".server"

    etc.install "distlocal.json.example" => "kcptun_client.json"
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
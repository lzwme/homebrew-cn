class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20241119.tar.gz"
  sha256 "a591b539e6a0d2a3b652fa5825fc81b4c3b087412d8692403b0b831fd11014b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e754203653cd7123085ce354428cf8d8ed36b405ea2c44b3686fd0c765c90cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e754203653cd7123085ce354428cf8d8ed36b405ea2c44b3686fd0c765c90cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e754203653cd7123085ce354428cf8d8ed36b405ea2c44b3686fd0c765c90cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a487148a247e0c89be74e128ca79028404954d877253d41362a2e5a8878a8fa0"
    sha256 cellar: :any_skip_relocation, ventura:       "a487148a247e0c89be74e128ca79028404954d877253d41362a2e5a8878a8fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ef46a9d268baf75d725bf3002185fc31dfd3af862e9b4c4750802125f1e24d"
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
    sleep 5
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
class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240706.tar.gz"
  sha256 "f9f1b4b992917a3e40cbf169691c78b57ae81ac235bce34b8a3cf9844bf82dfa"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8a5012b20f790756fdca928db02376166209798cf2d69a20eed93c2e053a20d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeabc141d4f1e0c34dd61efd181c00130548ae2a70138dcafa9b35870073d5aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c783e78ed2f1465a67f7a3365a70bb1fa003bf0e85593a002b336a67b96440"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca94ee53e11c45a8ee68330a37939271e4a9d826016658042409df2feb7beaf3"
    sha256 cellar: :any_skip_relocation, ventura:        "3e60c9e594b2c4fb956287acb10cb90a950dab72110de3542c5317826bd61fbd"
    sha256 cellar: :any_skip_relocation, monterey:       "d81d95eafe7b867c31dcadd9ea39cfe9228eabb3d68175e55d33b3380b3b3f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff30e9ee6a48633ce5fc0efe029fd43dc5efac3d0257317ff8786f18473130fa"
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
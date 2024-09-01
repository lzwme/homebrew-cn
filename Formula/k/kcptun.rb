class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240831.tar.gz"
  sha256 "469177fca95df495b3dc20c62995bc2deb4d33e5c922b2605c87dcf7e46f641a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2487d7a1099d139b671f0de8f76539c1e831b9d0f231e3efbe10ab2b1a137d27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2487d7a1099d139b671f0de8f76539c1e831b9d0f231e3efbe10ab2b1a137d27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2487d7a1099d139b671f0de8f76539c1e831b9d0f231e3efbe10ab2b1a137d27"
    sha256 cellar: :any_skip_relocation, sonoma:         "83e8c6bd91df34ef8179a31a1e9b4f14c2d021a86b23822f72e155a55f7cedd3"
    sha256 cellar: :any_skip_relocation, ventura:        "83e8c6bd91df34ef8179a31a1e9b4f14c2d021a86b23822f72e155a55f7cedd3"
    sha256 cellar: :any_skip_relocation, monterey:       "83e8c6bd91df34ef8179a31a1e9b4f14c2d021a86b23822f72e155a55f7cedd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462eb26d9cbdad1e28aecb9e605938c815e8f20511e7acac2ee78de0eb5203f6"
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
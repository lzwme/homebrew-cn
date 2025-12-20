class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://ghfast.top/https://github.com/xtaci/kcptun/archive/refs/tags/v20251219.tar.gz"
  sha256 "766fda88f4dd3491a8175117f8db13347b2182178d463a21b8d19e381f3ad515"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ba25b6b4dd2504e1962eb944f6ed09a5800f1945dac8668b45aa8365a94cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14ba25b6b4dd2504e1962eb944f6ed09a5800f1945dac8668b45aa8365a94cc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14ba25b6b4dd2504e1962eb944f6ed09a5800f1945dac8668b45aa8365a94cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d060bc0d34993aa0dc14e94569167cd8b3e3c1da9d0be2c182cc1caacbc4db9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2ba2431e122d247e087878a927b55347a7ad6d5cc23a61b58affa889fddad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff747d29e3cbfe2155c55b698be8bc9cdc3380fd14ccb0b2ac77b22468966db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_client"), "./client"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kcptun_server"), "./server"

    etc.install "dist/local.json.example" => "kcptun_client.json"
  end

  service do
    run [opt_bin/"kcptun_client", "-c", etc/"kcptun_client.json"]
    keep_alive true
    log_path var/"log/kcptun.log"
    error_log_path var/"log/kcptun.log"
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 5
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://ghfast.top/https://github.com/xtaci/kcptun/archive/refs/tags/v20251113.tar.gz"
  sha256 "7f9754186f1adfdc33c78f7a6cb3204b232837da9f21a4a272ee7e5598508de6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "021c2eb56f2487e4b14c4696cfeb275d78ec7f338f0d1a26487e0d702dc3e2d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "021c2eb56f2487e4b14c4696cfeb275d78ec7f338f0d1a26487e0d702dc3e2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "021c2eb56f2487e4b14c4696cfeb275d78ec7f338f0d1a26487e0d702dc3e2d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "108a819bd7c51bc65310b3c0d38da1a49dc5c0267b5b878261b40272e14c42b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509f239352737a0b6123e34c099c62caba06e140d898000a06b5e05931df0094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb9d4edd0b4a423c13197e1c75e43535bdbc950ccf8d14a7b7969c9e3e25484"
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
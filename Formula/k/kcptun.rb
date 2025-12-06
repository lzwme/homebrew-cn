class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://ghfast.top/https://github.com/xtaci/kcptun/archive/refs/tags/v20251205.tar.gz"
  sha256 "091f73c2d28f2f7eee55810e1230c23e3d0299aa2a78959462063065de54e2bf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a135d12382b8fb2d6d0fb3ea0bbe5d9ebb1065f948a1978f090513196a14c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a135d12382b8fb2d6d0fb3ea0bbe5d9ebb1065f948a1978f090513196a14c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a135d12382b8fb2d6d0fb3ea0bbe5d9ebb1065f948a1978f090513196a14c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8cdb30e57c4740cd298f731d60cea76ed6b5bb6651e58a16cc8c6b7418f693f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85da011fbc78fd0cb4c0e3cf4a0250e357bb20a5de1c71207f1b671c3b1e398f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba70fcb0a66ee5db627b75c1d8ce6bd92d40afd166dfbe9a326cecb6c6f0e5a"
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
class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://ghfast.top/https://github.com/xtaci/kcptun/archive/refs/tags/v20251116.tar.gz"
  sha256 "948092d2552b01db3066f462cff6887205a5e643113215ba48607dea6fb5f1ca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee13b9308ed507aafa085da9b681a56f788dbd009e631f9ef026a73dd605d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee13b9308ed507aafa085da9b681a56f788dbd009e631f9ef026a73dd605d52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee13b9308ed507aafa085da9b681a56f788dbd009e631f9ef026a73dd605d52"
    sha256 cellar: :any_skip_relocation, sonoma:        "6961c70255f05c11a801171e421f4f0b8045e4b42f62c37125c815ac8f875802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b9f818b9b1ef3a01d268e92dc9a4b52470e38b4047b68ab0bedb6ce4737c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c242dc48c0c1a2822c170f3411f4dcfdf3dfa917766ae55b8a89f1a3531f287"
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
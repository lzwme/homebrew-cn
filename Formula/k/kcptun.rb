class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://ghfast.top/https://github.com/xtaci/kcptun/archive/refs/tags/v20251212.tar.gz"
  sha256 "19e7f7786253d82e89f16a42c8e1088cdd39d043c343cbfc25a4db4ec334c9b0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb01ca949de3c547a7cf58e7004971cd34e91ebbad681235b708e1fed2897cc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb01ca949de3c547a7cf58e7004971cd34e91ebbad681235b708e1fed2897cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb01ca949de3c547a7cf58e7004971cd34e91ebbad681235b708e1fed2897cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fad737ce695dfb8de3a28b33ae2492382c06939c5f9b141cea0ca953b321d9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3f0bc60895a6fc43730a6674917317196e51479f828cc919300ff973481a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3471e3abb98a767d8f92c1aecf6121daf6a728d14ed4a13dd83a7d72ba927c39"
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
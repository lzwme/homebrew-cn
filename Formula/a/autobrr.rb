class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "b6a397553036d7a7b0d1d6e26425098f5f55db0cfee2029a386180e9bb8ce272"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a94d66b2ff371de58f37b45ed6804ae28128a14ef535fbe26a277572dc0f54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9461c2080a0db1dd3f1a4f31ddc62f8e169c00bdfd5948abec1de0d5c057f677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0c472952699604e5f1efbbc31a15e00554e17594e3824a3c58b555efa75618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa90b7c88d24e024fe84c466317d53133c69ddb647e87092c8ac4ad73fe279d8"
    sha256 cellar: :any,                 x86_64_linux:  "f020ccfd5ddc4840852b0934acbd9fee6310427f3d66d934716e1b3624d35343"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
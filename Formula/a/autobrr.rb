class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "473ffb90c42b44081e3c063e31086f6f17b498cea2199a789c39fc295a594be3"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f5df0e668e7d3678408be2d668bbcdb096a4c2c9c36d219cb64e82f9e012ae1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99839211e6f2b8ac65a6b30258360646e331c0e80ac0feb1813cb8a87b5fd581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "689cab201a2d659990a8242ce58ec1b678134a5c8de67f0c9e82caede45a83d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fe807e309b5fa3a30bf19202e497602754503513182fb763b5ac0d595b55f0e"
    sha256 cellar: :any,                 x86_64_linux:      "869ad2e30318e74a81f3cfacf4514ecfb4875171b4b3bae29a1b65c7a7abfebb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "web", "fetch"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "web", "install", "--frozen-lockfile"
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
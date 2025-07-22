class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "d9cd7a47dc3d49cae8442c919094033044b586930b7f3c9e678d89d37b37a671"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143ca5689130d66c225488b281275abb760db348d9e1769e7f8dc66b430e0e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55644e23e1d92d4d5f9472bfc8823cb048447bc3144e7a3106588138d6b03e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77de1974ad4dcb586b32e523e4734565e40246163a9ef889e807bbd215ac526f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0529b1ffd7bb9ea44851c52d377ae240b7598ad6816afac2157395941cbac6e"
    sha256 cellar: :any_skip_relocation, ventura:       "3dde83e1fb5f08b8caa8669224144676f80190b5e3084ce950c4ce5a323f0ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6039c471ba794222970a172b2590be1f4c6bc63ddef82252f8ec79ed9d9300"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
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

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
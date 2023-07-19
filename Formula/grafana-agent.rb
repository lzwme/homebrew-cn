class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "e47b6b45d5826d6cc0acbe35b7072f22d1edc60b20ce3a2fa0ce814c27c6283a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df1c1cb86e2afbc0a79f2a2fcf8505ee7b26168f3131ef49e74efe671cefc96d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0038d57b08bf5ffb9bd85aa3f0ff9f5e1071a204d76cf08a7a174f9271a3af7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c66ea073b54c1ea7fb65d2cb7ab6d0d7cb9cf88a5f3ecf6fa8e503de95d1522"
    sha256 cellar: :any_skip_relocation, ventura:        "5a04b35e9d7bac50a782a0289afd799c3bbca3b7b717aaa44413df458185bca6"
    sha256 cellar: :any_skip_relocation, monterey:       "2e3973125b7a1b14a8c23d23803b91c43468e34865b36d5d6f4b17255cd5cfe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4fcafc0e23217fabe77eb9f4b3a01aae6ef5fd3961823b22eed89eaef1546cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ccf9a417a3656e09a4ff9850262326eb329949b4bc1f88cb51520172823540"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "web/ui" do
      system "yarn"
      system "yarn", "run", "build"
    end

    system "go", "build", *args, "./cmd/grafana-agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/grafana-agentctl"
  end

  def post_install
    (etc/"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-agent/config.yml
    EOS
  end

  service do
    run [opt_bin/"grafana-agent", "-config.file", etc/"grafana-agent/config.yml"]
    keep_alive true
    log_path var/"log/grafana-agent.log"
    error_log_path var/"log/grafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}/grafana-agentctl --version")

    port = free_port

    (testpath/"wal").mkpath

    (testpath/"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
    EOS

    system bin/"grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}/wal", "-server.http.address=127.0.0.1:#{port}",
        "-server.grpc.address=127.0.0.1:#{free_port}"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "b642f0328eec09bb69170d9b8de942b4d28303adcf33f944417c7c30d40210f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1adaed1af8056ea1348f6b90ae6cef321c25303a7fd1af9b63225f4240141e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e288e071df742a67f3a144f8eddce0b559a958ca088cee80f71bc69ac93f9cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eca2a5234c43b5268f73f42e8536f9aa41539d6d55468e58f61a8f1ea9519341"
    sha256 cellar: :any_skip_relocation, ventura:        "34c0455c374fb0cee32261b4c1f5e6e5195c35a40e45b121dba2c13979d2b6a8"
    sha256 cellar: :any_skip_relocation, monterey:       "c2bddba36e250d8cef5024ad3bf385d967a39a4e680ff4721277577361fd3d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "66e65c0330d23c214d6754f9dc5d1f20a2322ba2a6625225a2fe96102f0b696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a575e3f0507872f4e5c1696aa8e3679e8a412ea068f073db6d5aec95db0b74"
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
class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "c16a1b8330eb3db0dfb6ab8652d089713e793b4bc9357feeaa7a38f068c23633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69bb0dec226e36ebca76fc779e0fe893f610c1ff1034d55432aa4841c9600943"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc186694cebbac1d73e44afe498f325b90ce0b7ac828c1d9ac43d1cfdc2720cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "782e0f4fa5896b83d4da684e4de8cf808c51efdeb64d459f2131100b6c6e7a32"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc3950b22a2c953d7b7dafe4c4bba64f0050061f32035ef426de2ccf5907b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "32e4ead4474318cf9e69655c947333b7517a6f0767146ab300292d71989cc75f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9061b3d8225dfd19c8dc4d8a7a0ab014c88ca2c1e3ef511426c67b0b5587e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a7be6517acd04c4e8df63afa2997a3785223dc334ea4a7ecdbb25c775149e8"
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
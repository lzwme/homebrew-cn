class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "6d5aa747104d4527417a2cebf7a78f46e07e6a095d02dc62d7ef3b644af516d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47335847fed6a89acee069edc649da8cf1c585d0a230e89c02ad457b03e5c5a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39edef4898811aaf8d99869bf6ec755d2eb02f8874c6605631ccf740cbf29f35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "129fce913d132937aeae1e3705eb6b99344b4e0832d7207c54514d92791ac775"
    sha256 cellar: :any_skip_relocation, ventura:        "7ffd3031e2d4c889c5a5984d6d14a03535e97db6f964450173b3f61fa83dfa82"
    sha256 cellar: :any_skip_relocation, monterey:       "29954db40eb1e2a0fdc4e5ae4ff7d9ae436289b0a938e68a7922314e0c7dd916"
    sha256 cellar: :any_skip_relocation, big_sur:        "8efa32d1c26f57208a1417c63b8684474bc13c30dabb6b97365626012edece60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df6091bfdced55446f6a924dafbabac7b5f1a03d9180f73e2a9fd90a18f2e65"
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
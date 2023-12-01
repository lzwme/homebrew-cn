class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "7bb0510995257c4bb5fa92866899752093fd8d0ab63830328e93da4a6a3ffdf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff6feeeb1e45f573bf07af735c53ba4ed099c29f57ed89921cd660ba6649a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0855af1ff7d9f37c97dacbb0d1f13bc53d2925752deeced42ed6afd5928ef07e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb6c1478662d7a4b9473f8e83e56106b1d402be2f0c6af6784c1cfa1bc77691"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f1c13ac23ad60e300b2440f6164db75d9d7426663fe66dfa650fe46581a61c"
    sha256 cellar: :any_skip_relocation, ventura:        "c3880df32efd8d825289bebaee63a4fb90908c52bbfa99e9b953231fdc3d9164"
    sha256 cellar: :any_skip_relocation, monterey:       "d220f9ba90ab8a06f7eecd83838630992ad4c8b49fd1b6519698be8d0ee890a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f16c7e24cf628a64acbd72d0d8399f54d3c01cb3f95cb7cf231e172159ebdb"
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
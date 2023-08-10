class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "baa556ac762faa8a8396e3033c44ced4a56ded9f459760a04842425a206f6f2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d202c4270ab33fec1802f34bb5e7f0b89e66d547a5e5052a6f5ab575449c4c13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661a6665027ead023de0e420943579f6d502b5e2ee9918b00bd6fa135234cd3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87474c5d5ee384dc72c9e732b0dfb70b895602c0b3cbc0b23392e79805de5a83"
    sha256 cellar: :any_skip_relocation, ventura:        "fb96db4794468a5b0895d05f1282c785a47c06c740b50927a96103ab196e251b"
    sha256 cellar: :any_skip_relocation, monterey:       "78aa17b88e9a5ee88d5778adaa9b52a982870cb5bf0a766a5c7cb975a0f9f408"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f00052dfaaf557ab80b2d6f59fb1deed643be9648fb65e1961b657eb25c910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc16fc6927ebf5843e2ad6ed1b9477cb08e5fa1333be49d61c7aab93b311245"
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
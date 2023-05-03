class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "992a178e1e5523120bbc58454f304b84cf5612b99669d65284c843df656188e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d56f42d6ea91aa4b8fd96f6a5ff3f46d111ba64881d70224427496759c966c4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8861133a079525b598346ad3a2ebcc5f4afdb0d293e4497ff36e259778993e8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daa6b5185669440c62a818432f5bfa440affc00e1e6cce0d52fbae4e3c51842c"
    sha256 cellar: :any_skip_relocation, ventura:        "3824f0b943fbb8d8b095d5a721b6d43c888cd13b07eddde061602a4de1a5b808"
    sha256 cellar: :any_skip_relocation, monterey:       "433db6fb0e99b67d75fd36f1ecb3a8d7a80f3176ab19f0e07fec84bc1233cb8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "532cfef9e83b950bd43524c0e18d8b933755139703a73488d7e1e21ad7a2cfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b39140944691990aa960dbd0d93efe62514fbff8b8dd893ec70b3681cb7cfe"
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
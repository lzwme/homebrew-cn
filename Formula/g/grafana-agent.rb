class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "db46886fd0ef56882e1e70768b709d6d8d41ebf76e534e39e3663fb7f6b4d2ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6400c9ebdc86ab3806446c9faf1da1bebadb8642cdb1d0d5ac4274c89f8a25c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8790e5ff1392b4e01f19ed789f4bf09058969254a1fdd8500e37712e2238891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f113b8d23114b8dcc1d2c4383d5747abf149caf198899a2341fddcc1a6d56f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b03ed0005ddc8931f45baf2d9cd4efaa2fd752adc75c6ce727a4c840ad509ee"
    sha256 cellar: :any_skip_relocation, ventura:        "a74026a4add54133350f4508eb697a22e05a5d584df26485c8a1a6da957b4381"
    sha256 cellar: :any_skip_relocation, monterey:       "40c2ddca1478f439529ef4e4dd17ae59eafa172d6d0b9ca0922a6e83013bcbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f68ea99d13d3cd47fcf51e94d4437e4127c467b4b8e216b1078ee12f8fa3b3e"
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
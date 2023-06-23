class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "6d8bd7d034aad6fa41a91ab21a9557ce39d782a6d1da3790204481594f8c58d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c228f9b86e34aa8aa6afa4a772a443f1ef2f4e4ea95344b0a92c6a940b581da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a43e52f53696a05dd49bdbbdca0347ba36292ef44474481ec39b7deb931d71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc6e35ae2d57a3e9ca500c2fc342c92acd329279500f8d973f57f11f9fbba4a"
    sha256 cellar: :any_skip_relocation, ventura:        "73f67d664aa29edf1429e26ece3e4952790853f1b5e7af45534687eb0dfa5869"
    sha256 cellar: :any_skip_relocation, monterey:       "6866fd8039cc0962747f1745c852eff1bfbac2e95f35b06f5f2829c380a02743"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e869b8a436c4af8dcb3d6609253f96f8df416dc5641ad2d23e02e91cb15609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c35470d83ca6cc2b02d452aab10436e8ca10f6a76a1a46e0a5ae20001544e3a4"
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
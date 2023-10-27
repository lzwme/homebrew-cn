class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "415a018f302d1ba64902049fa991a32f83aea8c784bbe91a8ee554f8c77fe265"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05149912680d91f90ed2da1fa76ab0f0aaa23f0c392cca3ecb3d7844439adc94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86ce7c8e2f6138a513a3db40299ca2ffe20a2622ebcfa4179396879b2ed3915"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c0c5677e80c76780ea1b912e00f7d3f2fceea8ef4a583b5180256801946316"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f88319b1608e88a652e77bc509e5bf20c7700a0105b3d8a587c887e98d2e34f"
    sha256 cellar: :any_skip_relocation, ventura:        "e61ca761c49e603a3271914dbd60047994e2bcaf663b086a69d45c1b128c3c95"
    sha256 cellar: :any_skip_relocation, monterey:       "4278aa62663ab8765a763564a6f13b2aced8c4b46c686aba217591352e969355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843968ea2c2eeb976465fef7635c35b05ce17be4e91bb246fbab8e2587ec3915"
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
class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.40.0.tar.gz"
  sha256 "9b62645f0c1cbc62e1e0c4802f283fd201bb9a1f8c6da2cf9c244fe662a3c651"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a0a238646b971a32eaa2e026571d454c99c94b3fcc49f5b14638e0d3ae5bc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3231b67d02c20014c7605188719b0937c93d39a6b651668a943b54077a064313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c5c92728518d6eca195a0f3753bfc00d8baf7b9105215c48ae5196b3d0581d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1382e4c743595d4f94e75e6b53a0902e520c25ae04032f34d0100fc80737752d"
    sha256 cellar: :any_skip_relocation, ventura:        "ed017071bff81e208defd680febaf0726d31a33f03a454dfaf81df840d5fbfbc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e1c2b616772e58ed1578eb5b0d0ba3e6c6fa3ae84e91b96a84e21d18b1dfb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfe88f8a384d2aba2530e1e4762d8920f850261ffd6fc83e52b8d52487f55358"
  end

  depends_on "go@1.21" => :build # use "go" again when https:github.comgrafanaagentpull6139 is released
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comgrafanaagentpkgbuild.Branch=HEAD
      -X github.comgrafanaagentpkgbuild.Version=v#{version}
      -X github.comgrafanaagentpkgbuild.BuildUser=#{tap.user}
      -X github.comgrafanaagentpkgbuild.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "webui" do
      system "yarn"
      system "yarn", "run", "build"
    end

    system "go", "build", *args, ".cmdgrafana-agent"
    system "go", "build", *args, "-o", bin"grafana-agentctl", ".cmdgrafana-agentctl"
  end

  def post_install
    (etc"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}grafana-agentconfig.yml
    EOS
  end

  service do
    run [opt_bin"grafana-agent", "-config.file", etc"grafana-agentconfig.yml"]
    keep_alive true
    log_path var"loggrafana-agent.log"
    error_log_path var"loggrafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}grafana-agentctl --version")

    port = free_port

    (testpath"wal").mkpath

    (testpath"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
    EOS

    system bin"grafana-agentctl", "config-check", "#{testpath}grafana-agent.yaml"

    fork do
      exec bin"grafana-agent", "-config.file=#{testpath}grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}wal", "-server.http.address=127.0.0.1:#{port}",
        "-server.grpc.address=127.0.0.1:#{free_port}"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}metrics")
    assert_match "agent_build_info", output
  end
end
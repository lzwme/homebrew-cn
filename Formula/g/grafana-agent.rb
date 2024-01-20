class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.39.1.tar.gz"
  sha256 "979dc27f8e9b44499044e62985927502c1c38c72316fc36ec1f30181d611fcee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "603baa8ad1655759613b5b941bb6465ad7d12427b5b85add15a6150cdbcc920a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68433929ee8a461e3735738db4985d16ac3f542f5be217f5bbb964914ab87b82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bef6504dce54f5732637808e9b72fa47fff6aec5a1f293fd8cbfbe3c8629373"
    sha256 cellar: :any_skip_relocation, sonoma:         "5df88bc995e234471397b28f62f84287f5e2c447977559397a86daa44c851f3d"
    sha256 cellar: :any_skip_relocation, ventura:        "94629290bc83b3a6dc8d11fd898df893667ea2262acba2ba7ba4880e3ac03fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "4080bbcbd16a04ba37f0b02fc4165f5ac6e6d0a08b6005d62c9a8a681dcd51dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574ce6753efe877d1452d81b420d4fec5cdc0b66a159e2e7f27011bc8812ff14"
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
class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.43.4.tar.gz"
  sha256 "06d0bb36017e8298c5a775ad44fb83a05e42f0c4654cb33ab29fb4832e922c3f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6490f17f587fd91e60cc621ca3a541c9a8db4923d474dc16050e366b36e4933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b0076fe7823a1f57efcc9b17536ff4345b4ab131f5a83a0d5da3e9f6e47d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39c0457c500c07966180bc5b9298c2ccdd5517b967357e40fb305eb44d225cc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "117751e5c6308d96f4f1bc4093a07057811ca98234be5e25908ad726761d53e3"
    sha256 cellar: :any_skip_relocation, ventura:       "1413ef79c54aa0dc96fc7ab09f34e0a650fcfc9f94ac985c3b7993d9ab622077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb74954c3365d544b2efa5e1862fc2602317d89a12532ab870850ae34cebd055"
  end

  # use "go" again when https:github.comgrafanaagentissues6972 is resolved and released
  depends_on "go@1.22" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comgrafanaagentinternalbuild.Branch=HEAD
      -X github.comgrafanaagentinternalbuild.Version=v#{version}
      -X github.comgrafanaagentinternalbuild.BuildUser=#{tap.user}
      -X github.comgrafanaagentinternalbuild.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "internalwebui" do
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

    (testpath"grafana-agent.yaml").write <<~YAML
      server:
        log_level: info
    YAML

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
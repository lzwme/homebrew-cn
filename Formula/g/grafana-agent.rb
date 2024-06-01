class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.41.0.tar.gz"
  sha256 "461df99f8d3fb241e1ce1e5400a35f67aacad01d57db391301f398419aa1df1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de4d88951c4fb1598d8f8dcc67f7476ef8d200ce83cf7963bc5a6e7588d5319e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8dbf76bfb1b698c9b8108ed0729eab27ce5c2e3b8c0596b809633abeef830b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f0169556dbcec3493cb23d4187f81ae42ede5567423d203403b71fe5b480a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "68c4e2c1d6b773358797302cfcef362845bb59951056e485c403291003034a3b"
    sha256 cellar: :any_skip_relocation, ventura:        "886e57ae95a173216273959d6c68fa863f23af000ce1415bfec5a6e239f6c6e3"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6474848758b2b5fcb34b5b5fedb5aaa47642b0288e5278343c7253e89b0047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c195547d48b12ab45b6bbd80d3c3c53dee80ea210248ba9334601bfeec959b5"
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
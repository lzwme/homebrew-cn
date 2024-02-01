class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.39.2.tar.gz"
  sha256 "54105d08cd2db3e0116677dcf651593136a92093bfe7453a7ee7a678a64adab9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c86ea0828f3a00f2142396947767dd7427028eb65f6cd84eea8c49289386a505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287ef2e16ded11fb44c6e8d625a9bfb3e3149c7f78f88cbdb56a086df0ba10fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34686e225647d9e123f0f9be89a9693ab8ea4fb1c74e2c929bc9e1d6efa83972"
    sha256 cellar: :any_skip_relocation, sonoma:         "263afe9363fe568a21736d8fc0b286eff0ce813b5185e94d4453c3f1455d6fbd"
    sha256 cellar: :any_skip_relocation, ventura:        "569e8abf8904d7292fcd413253ca9bb06bc38c7807108079f25f4dcc70bb9e22"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce24977a92453ab7a76ea9375a05d2215bc30b2f5387b1754c14651ac50391e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35c1ddd635a982b507cb0212a5f185b43f4f3624d0e0d230f1e8f6d719c686e"
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
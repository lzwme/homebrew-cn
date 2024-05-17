class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.40.5.tar.gz"
  sha256 "621d64f4e4600fdf19292ac0fcb37f3413e561988993997c6503a75eb91afd88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31119704b3abf1fa8cbcc7eb4bcd24578a0b667e76ece4cb58809a787a090c84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d2e50959c468f804c55ae6513f1054d5b641f4a1254cde6bf2d6c2f967d5ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7af474b52384287e596dad056d4bdb32d7a5bc3d97b7ba239102d7100ec56cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee21d9000cc9c3f5df0b47f65b99c19b675e0756ec75d9a5e885131a170fc42e"
    sha256 cellar: :any_skip_relocation, ventura:        "c4cbee8a345d03b049ef5b241ce0ea589f50356d6721907a3791a8140613693a"
    sha256 cellar: :any_skip_relocation, monterey:       "0201a16e77f625935528eabd883effbf3e6ae39538cfebc90fd6563e92eaf725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed90affcda92cc14f16679f2b52e7614afae2d85951ec22fb1cb3ebdd9ec65a"
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
    args = std_go_args(ldflags:) + %w[-tags=builtinassets,noebpf]

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
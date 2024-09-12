class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.43.0.tar.gz"
  sha256 "56ef6a3f013aac5addc97c84301e27f6eeac2d3ee823c3ea0be6e21db35fb981"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eee11bd862010ca9c3e143bb8bec3d36accd514c14b2001321d44647694c1dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "754b18e81b7353246659c9cdf58911368e0215e3569cc8c532a020167f92bf68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3feb625e48341538e9f49392399ea3a793d9c4eaf22b4c91e62d37b367c2a3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f64dbf7298ccb5d82e78355ea1679f45a624301c957a654d57031e68d6b16b9"
    sha256 cellar: :any_skip_relocation, ventura:        "b54072fd96e4b9f8e6c810c3a24742a3b9791044e164f84d9b56b3fa90d4dd48"
    sha256 cellar: :any_skip_relocation, monterey:       "894777cbceac36e673172edb73f60d761d349879b9e00ce7dabd8bdb1f2a626e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5f720ebbcbfa8d77b702e013c5dd95d72458fd28ef2fff61ab8e9ecb34a627"
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
class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https:grafana.comdocsagent"
  url "https:github.comgrafanaagentarchiverefstagsv0.39.0.tar.gz"
  sha256 "3c8a273121e11681bc17ebeecec61954a3947d7e084af51ae3f05ea9b27ad11b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ae9b8d7a9ef497f1e1b819a02ab4207927164de10267c48ba052144772e595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "268963a32573ab3e44c810f6a7d80b5dcdf8ac7cf893606152a7f61187bd2773"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8d4d38f94d897c141d8644a5032cd84ee9db5aae04e200aee9a7f92c6fb3608"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ab9b4749edd5dd9f7a41ea8ae9de7aa553ff32c32bb45ec1f39cd2dd46d9241"
    sha256 cellar: :any_skip_relocation, ventura:        "8beb7108ab267adaf2839158324ab0e8404a1ee195154773a56e5a3736e5e783"
    sha256 cellar: :any_skip_relocation, monterey:       "952a679e5f15038fac98be5d9de3ffa37599b335f5536b92cd0e5ab752feadba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c666644bf137528424d04ac5cec2555eb0db1fea28cbe6ff6b7243a8f46b524c"
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
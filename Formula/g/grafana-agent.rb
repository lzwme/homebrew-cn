class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://ghproxy.com/https://github.com/grafana/agent/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "36184a526bbb3be276bfa67185c2ad05966768eb8dfef0890cd1f9328c4f70d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d56b2fd5cdfa3f33bf6ee4f173d66102bc6ed85cd050196bcd151f54621a93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9b4637dcbffddbf9530f3340e4b1828524f5f76279e842cfcd9d0e191aeec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6354ff17f59a0f190a5157bbb8518d09511b3df6d41e551a9739d01cfb0ea98"
    sha256 cellar: :any_skip_relocation, sonoma:         "63f3d548bb63fd2f219ec0b7597533df3996791f2c7fc1aa16599aba4ecbb51a"
    sha256 cellar: :any_skip_relocation, ventura:        "87b43ed9ea4af71b456a28b21ba72fad37da91fa93b8fe99a43dbe21cd0b7d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "4af23477fe2a9ce5807dd5f97ca88a4d1905a395a53864b1cedf919aa76f9e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a344f6ba0bcd21cdb129b75c43a13ddfec627d91c2470ea9f8241b1d342014"
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
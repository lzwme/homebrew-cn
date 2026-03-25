class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "23842245dd564c6c9e6025ee6101d85facdaa7fefd645e1b8796e46e162754ef"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f78f55d32b68bd38a52429cc40a364e201d9005bf4513c168f85fd95e61161aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492583356db14b17db93303c51124e43f9d8eb7a82089f3406966b155393e4ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cedec0cc9c00cd4b43e0460935bff676779e0cd3b93f15ef6b6dfb41816cb07"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd6a505c8939c9651c7c7804469d303ead33ac159daf828c04c51042e25150e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c39cd6ce1048e43b4bba89d1563efde0998914fa3bbba3283362409a858c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7b31d51485d9a861f94fd597971322bf05d0573d7747ae4321ec3a60bc9b73"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for godror)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo embedalloyui]
    tags << "promtail_journal_enabled" if OS.linux?

    cd "internal/web/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", "-C", "collector", *std_go_args(ldflags:, tags:, output: bin/"alloy")

    generate_completions_from_executable(bin/"alloy", "completion")
    pkgetc.mkpath
  end

  def caveats
    "Alloy configuration directory is #{pkgetc}"
  end

  service do
    run [opt_bin/"alloy", "run", "--storage.path=#{var}/lib/grafana-alloy/data", etc/"grafana-alloy"]
    keep_alive true
    log_path var/"log/grafana-alloy.log"
    error_log_path var/"log/grafana-alloy.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alloy --version")

    port = free_port
    pid = spawn bin/"alloy", "run", "--server.http.listen-addr=127.0.0.1:#{port}", testpath
    sleep 10
    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "alloy_build_info", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
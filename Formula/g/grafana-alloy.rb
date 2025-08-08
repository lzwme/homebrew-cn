class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "e0e7f06441081491b70cb52598158d4204e17dcfbe4eb626272da63cea39c573"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e95862fd92c96196ec4f7e5977fa76ac2d093d215114f6c5d2702b18d30b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9bcd7dcd1c916029358e9a8da0b7da2cf2d33388eb221f3c9969b65ba2a20ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45017c0e39cc49cfc143d214a56b7d9a4780c3ca9b16d2c8d9c2af4bf30194a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0699cef40eae93c6020f22be46870e9e52bbab2a29bb39705496b5c2315a297c"
    sha256 cellar: :any_skip_relocation, ventura:       "07836a3f9bb689d9c07cd6ae21a9757cc1d13c50ff60fb8f6bd65ef931d2185d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6897a0dac4be9e40cb312930442e4ebe9cf4863c98092383efe7decc6938069"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo builtinassets]
    tags << "promtail_journal_enabled" if OS.linux?

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    system "yarn", "--cwd", "internal/web/ui"
    system "yarn", "--cwd", "internal/web/ui", "run", "build"

    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"alloy")

    generate_completions_from_executable(bin/"alloy", "completion")
  end

  def post_install
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
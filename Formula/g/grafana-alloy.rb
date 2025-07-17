class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "205a23ef00055381782e8823744c84d2b1124ca6f3993e91c276711cfb0a271b"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9959875cf2dbaaeceb2c90607ff98fb02e868cb1f2413961978a99abfcb8c363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1deef7d2db828ec71ba1627c54bb49def4ebcd755121aeed6b18210b0b44b4a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62a14822a093779b1eb0009885ec6935d222e3e07d94234124737fb8ced6a94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e51e7a0ffe2e3626cdce59db3923f4da51e851b3ca95d812ce4791e41ef4846"
    sha256 cellar: :any_skip_relocation, ventura:       "8954f52f358aa96ed79a974992ac2da257f158251e372d3b8908691c6e6160a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b282c3443cfb6d03357adfb9396b882ea4c86b5be783d18a004ba006d51b1c1"
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
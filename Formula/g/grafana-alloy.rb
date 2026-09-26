class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "156870fee9c38c6ff7748ac3cda86da0f0ccd897cb52bcd99c3ffa7526ec37fe"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0dcb368bbccf99872d3e7b5cfc449e568545011ff68017d83a3af6c01afdfd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52b53598c5ed7039caae587fffe44af6767eb7452956939c72e3a0eb660d82ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38e2eefb2b95a9de21d00baded8af6a4643ae4de8d88ae0fe0358af122347c1d"
    sha256 cellar: :any,                 arm64_linux:       "13a19408af6dae8fd7b0f851994ba49eff3835a58cd0153f1feae0d333f300b6"
    sha256 cellar: :any,                 x86_64_linux:      "374fc753a177b370744f6b77b0b41bb2c736103db0c7cd6d0cefa95c370ceb46"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "collector"
    cd "internal/web/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for godror)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X github.com/grafana/alloy/internal/build.Branch=HEAD
      -X github.com/grafana/alloy/internal/build.Version=v#{version}
      -X github.com/grafana/alloy/internal/build.BuildUser=#{tap.user}
      -X github.com/grafana/alloy/internal/build.BuildDate=#{time.iso8601}
    ]

    # https://github.com/grafana/alloy/blob/main/tools/make/packaging.mk
    tags = %w[netgo embedalloyui]
    tags << "promtail_journal_enabled" if OS.linux?

    cd "internal/web/ui" do
      system "npm", "--offline", "run", "build"
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
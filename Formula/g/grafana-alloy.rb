class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "eae757e2bf67ba6ba45a0ca00e0c58d20fdddd8a17884201d6f3f87bb5686b1b"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cada51af817609213feb7b71433a310bfed9d9a5a52c59c59a5f1f4504eca0bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49fe294cb8f092eee28c88e0bf9522a02cfd8f3199200e45947b1b71b85ef140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318134b1e247d27d2f7b6b7c0f88511b2924f4a01a0f488d755476fa5b348119"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a7e0c954d8d7fa2d969866c155ddb33eb4f955ff1e963792a91f814110b880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b8e574c484947c3e4825de7c1c1e65c332dac68cfd36ad6564e699fb0d122a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14643ccd844131dd0d9a3f29f70dd7f7966727a8b543760d86815ecc5c3eb7dd"
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
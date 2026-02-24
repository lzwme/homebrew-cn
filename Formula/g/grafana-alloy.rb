class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "5cb793f8ddfb141de9447fb96cbd1c005ed500aeca1ef583ea399d1b4739dccb"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1daa39b202c1beafd34b03edf87a325f7497578592ca6dea11f9f3e11409e79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714abda40d9c2217127ffd03d0a01f3c6cd5b87edf0ce2921d5d9de80b11fec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcad10912412bbb6c976660b325ce25fce14efd8c8cc1e6fd1b8b1e0ee45382"
    sha256 cellar: :any_skip_relocation, sonoma:        "01121065e0bf3be51369d045b58eb6001c889cf40f3dc642334f0e8cf812c413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6d063a497988b8e6db2a5c39892af6ec00efd911a18da320c850ef9ac2789a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23b5884dbb68f16b403f38a69717d51b0b01be19a5b5d8da01e276205b16506"
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
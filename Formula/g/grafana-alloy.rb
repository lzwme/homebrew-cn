class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https://grafana.com/oss/alloy-opentelemetry-collector/"
  url "https://ghfast.top/https://github.com/grafana/alloy/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "ed43108bca6cbae25c130e16a229f517b3c66e0f22d3ade39aaddaae2639f490"
  license "Apache-2.0"
  head "https://github.com/grafana/alloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f305c48a5e85ea5d82ced399e9623b59f10f480d661fe12bf0d372c680ae4acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a4c6bd0c1909c70306a1e8b334aa61d0306f17e8b45ccf77f834ae5c7fa9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c87505c2020a13eae2b41f4df3ff51fa3b27641016a3f3aadfb21aae5c0ef5b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3cc7b7048cff44da7132c4304afcb4ec6fed23c9dfbb0efb58102e96cfaeefe"
    sha256 cellar: :any,                 arm64_linux:   "ddc1177e8e8c500def093d56285963d5e3ae76ffd70c4559713797d4fe701e66"
    sha256 cellar: :any,                 x86_64_linux:  "cefec32ea797426de8217a3bc3f83eabed8dc6f27d2409363e7eaf10497a485c"
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
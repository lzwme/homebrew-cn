class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.8.7",
      revision: "732d0f06a862762529eda2d2743986d6fff5e940"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a6c589f7c647e7e9e6b651b3aca6790b1eba8be6031e3bd0542c05f635b4885"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "739bc577094f6cf22049d1836b5d441e4c51fc4fde135b5e59c8734166d0f56d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b38dd54701a8b474c4b68ef25822a7d4a31b9e6f7d059a54bc47b53ded807a2b"
    sha256 cellar: :any,                 arm64_linux:       "e58892d7977e9075b6672c78995e8d6eb9fc9a0c327b40139cd76fbb06816638"
    sha256 cellar: :any,                 x86_64_linux:      "88137b53a056ca917784c3d0e550e13e2e73d36666ff39ea5948de4fb0b18217"
  end

  # TODO: unpin go@1.26 when kapacitor supports go 1.27
  # ref: https://github.com/influxdata/kapacitor/pull/2902
  depends_on "go@1.26" => :build
  depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://ghfast.top/https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/influxdata/kapacitor/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # `flux-core` Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"
    # `flux` Workaround for `error: private item shadows public glob re-export`
    ENV.append_to_rustflags "--allow hidden_glob_reexports"
    # `flux` Workaround for `error: value assigned to `<varname>` is never read`
    ENV.append_to_rustflags "--allow unused_assignments"

    # Workaround to avoid patchelf corruption when cgo is required (for flux)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags: :goreleaser, output: bin/"kapacitord"), "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf"
    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  service do
    run [opt_bin/"kapacitord", "-config", etc/"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var/"log/kapacitor.log"
    log_path var/"log/kapacitor.log"
    working_dir var
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, testpath/"kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, testpath/"kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, testpath/"kapacitor/kapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http://localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = spawn "#{bin}/kapacitord -config #{testpath}/config.toml"
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
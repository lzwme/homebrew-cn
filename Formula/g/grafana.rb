class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghfast.top/https://github.com/grafana/grafana/archive/refs/tags/v12.3.4.tar.gz"
  sha256 "0dc6d1d562b2b02a58f6692da316dd1591b89db7962db42d6da714801a2f8643"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5f4cd29db239455544e8fca90b95ab8d9f42e9f6534a658118ef38884a9ef5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f2fb67150cab7fdd7b81143e9afe6a06079267bd4abee14cadfb4a48dcd1f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd509884d5bf5cb4c9961b8e7e934930bbf78df2edc81b0a66d9fb16a34f646"
    sha256 cellar: :any_skip_relocation, sonoma:        "174b285d5e9d53db07d47020849705b8615fd20ad24ec868b314bdd8bceb30c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f16e763a7f619517e2b8386ffc986f1c3b16aca39b32d145076af7cf987702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563a0d360d668518f938dcb4e55edd90303db6aeafe305d63333a57ac4070208"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["COMMIT_SHA"] = tap.user
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install", "--immutable"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath.glob("bin/#{os}-#{arch}/grafana{,-cli,-server}")

    cp "conf/sample.ini", "conf/grafana.ini.example"
    pkgetc.install "conf/sample.ini" => "grafana.ini"
    pkgetc.install "conf/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"

    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  service do
    run [opt_bin/"grafana", "server",
         "--config", etc/"grafana/grafana.ini",
         "--homepath", opt_pkgshare,
         "--packaging=brew",
         "cfg:default.paths.logs=#{var}/log/grafana",
         "cfg:default.paths.data=#{var}/lib/grafana",
         "cfg:default.paths.plugins=#{var}/lib/grafana/plugins"]
    keep_alive true
    error_log_path var/"log/grafana-stderr.log"
    log_path var/"log/grafana-stdout.log"
    working_dir var/"lib/grafana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana --version")
    assert_match version.to_s, shell_output("#{bin}/grafana server --version")

    cp_r pkgshare.children, testpath
    port = free_port
    pid = spawn bin/"grafana", "server", "cfg:server.http_port=#{port}", "cfg:log.mode=file"
    sleep 15
    assert_equal "Ok", shell_output("curl --silent localhost:#{port}/healthz")
  ensure
    Process.kill("TERM", pid)
  end
end
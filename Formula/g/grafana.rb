class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghfast.top/https://github.com/grafana/grafana/archive/refs/tags/v12.2.0.tar.gz"
  sha256 "0d55795b21cf5494e5e3ff33627f7bbb940de9298d0a0aa86831c2f2f15fef1e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5afe706c4905ede4100772542b60269b34f8aa2792f71fbfe3ee9c6d0ad1646d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6681636017aabc873be6c0c2d2a096f4a9f00bd83227f58871a1124937237eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a86301fb03157e5c6d087ad83636a80a37463fd920db0a0f7942a38c1f2f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "d66dcdf170d155600a270419fe1986d755f7e84e5d1b631a52050c1b9533fa93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcced86eab069abc3a45b714994665272f7df2e6fda2ccf4ea281cf1b4b2ab22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4eab71243a16f295f00aaea2050c7542c1a4cc091c9a86b927e7e8ab1df691a"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "fontconfig"
    depends_on "freetype"
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
  end

  def post_install
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
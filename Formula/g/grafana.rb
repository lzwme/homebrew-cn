class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghfast.top/https://github.com/grafana/grafana/archive/refs/tags/v13.1.2.tar.gz"
  sha256 "ce7d55a43475f89a6637dc1057c6577c7fa70a1bef43771afba4edb022beece8"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec1f00ea48ec7d6edeafc49681839da0d72945161e88aa1356e88576ff9d24f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac9199753bcacac9dcf68fcd6a208b13e3f7cb1e1ed249d370d741fd287e52a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4ab822f8d2ff5b3e888ede3cde9a8dc366c9d95ffa20f2f27d279827077fd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "65cf9f8258c829265e508da606a3a92cddb784e399c46652aa77ef32d939ad79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c31151cd31e722298dddad6770a3bf67052ebbc94a5ced03c0f2309f831488d"
    sha256 cellar: :any,                 x86_64_linux:  "486315493fce9355c2b35c1c1da60d15a9109bfc4d5fd907131fcfc455aefa93"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["COMMIT_SHA"] = tap.user
    ENV["BUILD_NUMBER"] = revision.to_s
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "make", "build-backend"

    system "yarn", "install", "--immutable"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath/"bin"/os/arch/"grafana"

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

    cp_r pkgshare.children, testpath
    port = free_port
    pid = spawn bin/"grafana", "server", "--homepath", pkgshare,
            "cfg:server.http_port=#{port}",
            "cfg:default.paths.data=#{testpath}/data",
            "cfg:log.mode=file"
    sleep 30
    assert_match "ok", shell_output("curl -fs http://localhost:#{port}/api/health")
  ensure
    Process.kill("TERM", pid)
  end
end
class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  # TODO: switch to use go1.23 when 11.3.0 is released
  url "https:github.comgrafanagrafanaarchiverefstagsv11.2.0.tar.gz"
  sha256 "f1727b5e99183879e30d3ca8393e328f39f6bd8b5a11690e7b6e60081f99bbd9"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e3b2130bf2e1058ae0c2f2bcacbe7b96fc5fb5d4dd97a3fd97ccae7c31d1c6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "284947cbafa943186e6119c1c1fb8747e934d7ab892be1b2db472d5ba9f5310e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ab238b65f499ccbd852097e562ebc0f03c5b8c4c1b4cf98b2821184d29d973d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902f90003d932f350fb58645415e811dc6f8dcae641b023c5c9d0adb4be9579e"
    sha256 cellar: :any_skip_relocation, sonoma:         "12387f6ee94b61e1a327ccec62ad668793fb9669fc09ef3c371776f1201a4fb7"
    sha256 cellar: :any_skip_relocation, ventura:        "ebcd43744c90d19e495b874610dfa96dd3e324b4e756dbfe16e5ac3976121e74"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6e9df35d51470a2cd2c13f1d312c3d35cb5a1433afe8875526f240eaebc6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b17ca1a0f64c04558baf6176dcfd71e1c35cd6dbf7779f9fd5e16c262c856b"
  end

  depends_on "corepack" => :build
  depends_on "go@1.22" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  # update yarn.lock
  patch :DATA

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "bin#{os}-#{arch}grafana"
    bin.install "bin#{os}-#{arch}grafana-cli"
    bin.install "bin#{os}-#{arch}grafana-server"

    (etc"grafana").mkpath
    cp "confsample.ini", "confgrafana.ini.example"
    etc.install "confsample.ini" => "grafanagrafana.ini"
    etc.install "confgrafana.ini.example" => "grafanagrafana.ini.example"
    pkgshare.install "conf", "public", "tools"
  end

  def post_install
    (var"loggrafana").mkpath
    (var"libgrafanaplugins").mkpath
  end

  service do
    run [opt_bin"grafana", "server",
         "--config", etc"grafanagrafana.ini",
         "--homepath", opt_pkgshare,
         "--packaging=brew",
         "cfg:default.paths.logs=#{var}loggrafana",
         "cfg:default.paths.data=#{var}libgrafana",
         "cfg:default.paths.plugins=#{var}libgrafanaplugins"]
    keep_alive true
    error_log_path var"loggrafana-stderr.log"
    log_path var"loggrafana-stdout.log"
    working_dir var"libgrafana"
  end

  test do
    require "pty"
    require "timeout"

    # first test
    system bin"grafana", "server", "-v"

    # avoid stepping on anything that may be present in this directory
    tdir = File.join(Dir.pwd, "grafana-test")
    Dir.mkdir(tdir)
    logdir = File.join(tdir, "log")
    datadir = File.join(tdir, "data")
    plugdir = File.join(tdir, "plugins")
    [logdir, datadir, plugdir].each do |d|
      Dir.mkdir(d)
    end
    Dir.chdir(pkgshare)

    res = PTY.spawn(bin"grafana", "server",
      "cfg:default.paths.logs=#{logdir}",
      "cfg:default.paths.data=#{datadir}",
      "cfg:default.paths.plugins=#{plugdir}",
      "cfg:default.server.http_port=50100")
    r = res[0]
    w = res[1]
    pid = res[2]

    listening = Timeout.timeout(10) do
      li = false
      r.each do |l|
        if l.include?("HTTP Server Listen")
          li = true
          break
        end
      end
      li
    end

    Process.kill("TERM", pid)
    w.close
    r.close
    listening
  end
end

__END__
diff --git ayarn.lock byarn.lock
index 5f122101..b96cd364 100644
--- ayarn.lock
+++ byarn.lock
@@ -3233,7 +3233,7 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafanae2e-selectors@npm:11.2.0, @grafanae2e-selectors@workspace:*, @grafanae2e-selectors@workspace:packagesgrafana-e2e-selectors":
+"@grafanae2e-selectors@npm:11.2.0, @grafanae2e-selectors@npm:^11.0.0, @grafanae2e-selectors@workspace:*, @grafanae2e-selectors@workspace:packagesgrafana-e2e-selectors":
   version: 0.0.0-use.local
   resolution: "@grafanae2e-selectors@workspace:packagesgrafana-e2e-selectors"
   dependencies:
@@ -3251,17 +3251,6 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafanae2e-selectors@npm:^11.0.0":
-  version: 11.1.0
-  resolution: "@grafanae2e-selectors@npm:11.1.0"
-  dependencies:
-    "@grafanatsconfig": "npm:^1.3.0-rc1"
-    tslib: "npm:2.6.3"
-    typescript: "npm:5.4.5"
-  checksum: 10010a32e8b562d0da83b008646b9928a96a79957096eed713aa67b227d8ad6055d22cc0ec26f87fd9839cfb28344d0012f49c3c823defc6e91f4ab05ed7d8c465
-  languageName: node
-  linkType: hard
-
 "@grafanaeslint-config@npm:7.0.0":
   version: 7.0.0
   resolution: "@grafanaeslint-config@npm:7.0.0"
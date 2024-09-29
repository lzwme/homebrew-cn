class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  # TODO: switch to use go1.23 when 11.3.0 is released
  url "https:github.comgrafanagrafanaarchiverefstagsv11.2.1.tar.gz"
  sha256 "7881d5feb8942fb3adf42167534ded3efd876bc2e8b729ee4e693f096ee38924"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033a9ab8f119b781f571ac60defd2636e007dfe7dc860eb88819896f8d488a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172cd02cbe0e053b57db8892eccc37f6da44aecbb35e13550f752d5d4d13ec06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0bb0a4c465960237b150909574ef4dab85a41d25d7b1d4d3b4e90d78414891e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d8ce03672255c5dcff14381f1c609648c12b0f84f8f3652c07939e6eba4a40"
    sha256 cellar: :any_skip_relocation, ventura:       "480f989583dcd8454ec47f936554c42545af39a12b65d3490fd66ac532c53751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a53914e944e0b631462bda267dadbb8f053ef4f3487af7d06cda0998547645"
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

  # update yarn.lock, upstream pr ref, https:github.comgrafanagrafanapull92543
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
diff --git apackage.json bpackage.json
index bbef4b75..18c56900 100644
--- apackage.json
+++ bpackage.json
@@ -414,6 +414,7 @@
     "semver@7.3.4": "7.5.4",
     "debug@npm:^0.7.2": "2.6.9",
     "debug@npm:^0.7.4": "2.6.9",
+    "@grafanae2e-selectors": "^11.1.0",
     "slate-dev-environment@^0.2.2": "patch:slate-dev-environment@npm:0.2.5#.yarnpatchesslate-dev-environment-npm-0.2.5-9aeb7da7b5.patch",
     "react-split-pane@0.1.92": "patch:react-split-pane@npm:0.1.92#.yarnpatchesreact-split-pane-npm-0.1.92-93dbf51dff.patch",
     "history@4.10.1": "patch:history@npm%3A4.10.1#..yarnpatcheshistory-npm-4.10.1-ee217563ae.patch",
diff --git ayarn.lock byarn.lock
index ddae709e..7c38a43a 100644
--- ayarn.lock
+++ byarn.lock
@@ -3233,7 +3233,7 @@ __metadata:
   languageName: unknown
   linkType: soft
 
-"@grafanae2e-selectors@npm:11.2.1, @grafanae2e-selectors@workspace:*, @grafanae2e-selectors@workspace:packagesgrafana-e2e-selectors":
+"@grafanae2e-selectors@npm:^11.1.0, @grafanae2e-selectors@workspace:packagesgrafana-e2e-selectors":
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
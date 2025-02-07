class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv11.5.1.tar.gz"
  sha256 "f8f593871c432b300a531ab240fc3946aca5c559108e22e9a657feeb809c8527"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4a1492bf0eceadf08bf658f1165763f47f743470697544a0e7a46a66d2d625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a66b2194dec5212144e8f0033940f6822a37abd4272d6fe9c01df61bbb5db0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee9bcbcafda2f343efa31dbe71826a2ad31ff4a4b058b6d1206c3ac2ea0b72c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "257f75e61036799adccb10c8cad7c52201b2e27fa0cc32cfc5fc8e0e369aa93f"
    sha256 cellar: :any_skip_relocation, ventura:       "c74b932cc1d4e8a8ef98a64d59bb7e4329f78b5ed045eeb1d5b1c51f04986b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba87cf6e9041a8bfd83a1fd30a604dac6a44a91762c929980143b88caae70b14"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

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

    cp "confsample.ini", "confgrafana.ini.example"
    pkgetc.install "confsample.ini" => "grafana.ini"
    pkgetc.install "confgrafana.ini.example"
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
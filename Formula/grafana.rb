class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghproxy.com/https://github.com/grafana/grafana/archive/refs/tags/v9.5.2.tar.gz"
  sha256 "9dd2a9da40c5bcd7a14d24c8e6acb38865d948d5a45f806e6e6cb9f94a0c632d"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483952c8fdcde4fa41b04f44d7fdf3cacec69e417c986b2f16c28f9eb188441b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db0c93e18fd2ba87782eea85888534b747bf7d143ae9e1300f5ee2469f7fac65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6103cc2b01faba2cb05c84284104fe2df4fa8477086594aa2c24ea9e2a9880e"
    sha256 cellar: :any_skip_relocation, ventura:        "754ce674d141d6c4a70e059a61aa44af94c631876452b51651955cf4aa6e3aaf"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd6579bfdc63d7dfc356cdfcf420441868cf574c36c908889877d68ddd15b9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae74491bb25d86092b13e6fedc3d4ad075df0e928ab7e067d5b318353284ec0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126ec92dba9131e2290d978085a6e793af31c71d9afaad12257c477b22952bc7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

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
    bin.install "bin/#{os}-#{arch}/grafana"
    bin.install "bin/#{os}-#{arch}/grafana-cli"
    bin.install "bin/#{os}-#{arch}/grafana-server"

    (etc/"grafana").mkpath
    cp "conf/sample.ini", "conf/grafana.ini.example"
    etc.install "conf/sample.ini" => "grafana/grafana.ini"
    etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
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
    require "pty"
    require "timeout"

    # first test
    system bin/"grafana", "server", "-v"

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

    res = PTY.spawn(bin/"grafana", "server",
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
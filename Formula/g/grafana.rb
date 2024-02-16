class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv10.3.3.tar.gz"
  sha256 "6adcab7f2f1aca0895b17005fac2a0822b6c359a17542bddc0e09b76f128f9a1"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a7f45a1fa3621695bebc6d82493e809ebd543a8b1469e90cce97feb55c674fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ed0b5c9a7f84e97f1f4986af8104c3fab17f5f22b4733df5dc20f604bb98544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786bac074cf3927861b8830022344101aca35721348bc578bd1c97d0efb1f738"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2adaa53470db1d968180b7d318975a0729d55542e4d2261d5a92c47e9fda162"
    sha256 cellar: :any_skip_relocation, ventura:        "ddc407e2565d86120e4870d7025e8a08f7d128cb7f84d728d72052b3e99223e8"
    sha256 cellar: :any_skip_relocation, monterey:       "5d08c267d90c25bd344423ae933a737acbca3038d52f9df26b5d68dd6e3e174f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fdf45c7457589cde263103cefe7da9216c585fd2ca4bf97c8d1c896c73fd14d"
  end

  depends_on "go@1.21" => :build # use "go" again when https:github.comgrafanagrafanapull82114 is released
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
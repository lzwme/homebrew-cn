class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv10.3.3.tar.gz"
  sha256 "6adcab7f2f1aca0895b17005fac2a0822b6c359a17542bddc0e09b76f128f9a1"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe5cb3024bdee3e0a504ec227bdda5011367c08042b9e42938f9fd4dda3e7d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecae116207dcf4ea65a10711679e450cd0ea385a0c457e46aad62b8c87de240e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c76d34b7a0a172d79f49684a5f2583b1789a196cad9c63799b66bd5272b12cb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2004e88b187f30665accdaef2dc239fccbd7d8378152da899f5399acf8584825"
    sha256 cellar: :any_skip_relocation, ventura:        "043b06e7407dd5fab39b234c63ec4b8e3365c394795ecc3408a392b10192a971"
    sha256 cellar: :any_skip_relocation, monterey:       "4a4fc13725327d178e5dd9cefdc358ab271a8347ceb81d4667d9f7efa42278fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8d77a8b68c8cf139b3406afc79ea4ed1c7985370fbb15c537275fe9129af56"
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
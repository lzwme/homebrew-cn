class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv11.1.2.tar.gz"
  sha256 "9ddc13d9a567e3eded61d1e236aaa6c692d43d9359a7698ee60564039cb35ea5"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f933dfa8453830bee2c21353d4e7cc0f06338cd4e797ced84528f62226ba42cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c4366e3ebd15bbe626e8ec475899a019785158c5ccce5724b29c803303605f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76250afe49d38635b4b9e67a9721ea1798050cd144caeaacd6a48a2bfdd08aa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "22a44bd531c2f6430ecee3666289d0c2811989f4c1478c18aa90738c0170dcfc"
    sha256 cellar: :any_skip_relocation, ventura:        "d01dbf9cb0a3b7d6bf3085c910cd875271dd82f9185998f5b9aae698e560edfc"
    sha256 cellar: :any_skip_relocation, monterey:       "945ea02a341cbd2edc3fd9d9222553b1bbba188737339461a28cb6edb95fdae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee14319c8a23247602e80c4674286c228bba6b474bf7d9c6e0c531fa3c911775"
  end

  depends_on "go" => :build
  depends_on "node" => :build
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
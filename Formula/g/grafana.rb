class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv11.3.2.tar.gz"
  sha256 "8896a05d277acd4fb6af5349ad1182057e709c514e3e33fde1e24c1ccbc0c05b"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38269b5aa96e84aa10a0ecbe591e9e602c987cd1af208c5da0b59955232003a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcddbaff70399f954baa63072b3d0722aee76209b4b57fbbb6bd4939e403b0d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8997ed60eac228eac767e0a047b512766883b4c0766e3f570a23d535e9daaa42"
    sha256 cellar: :any_skip_relocation, sonoma:        "214db31be1e6028e0b882273be550fa3a8578fbca998164382ed0e685835a010"
    sha256 cellar: :any_skip_relocation, ventura:       "beb54fd45198530d86ca827c37798cf892617206a4fd7d454b8c4e30b9c338e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f354e333607a3fa287dc6b7e6e2ca37781b6c793df5f020e66d798fe390bcf8"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"

    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    system "corepack", "enable", "--install-directory", buildpath

    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system buildpath"yarn", "install"
    system buildpath"yarn", "build"

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
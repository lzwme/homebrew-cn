class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv11.3.0.tar.gz"
  sha256 "488e403d9dbe694c24e7b34d16568a3d750e7d4fd080001b0adb279209e9f6fd"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6cde2d6c5e284de3cb0e338318f1573bae425b11e58c4dc18703e1edd9c5a3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3979622b3e2b2a04be8e7ae74c96d561c3c35695591061cb50d8e5f03ca63d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32f56ef860817e2a2a75b5a0f5db1957198535a8eadd43dd14801f71ee9d522e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d93a8789f47e58dd99e201b4f57d40e362ad18da28abe59cda565cc35cce7501"
    sha256 cellar: :any_skip_relocation, ventura:       "66cce156ae3c091d2051bc66374b5f77dedc09ec5a14da1b59369ed294efaedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a991b2b28dd98b90bf7c03da0683beb57f17f28554c47a2aead4c9eac2fe00dd"
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
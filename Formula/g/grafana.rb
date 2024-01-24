class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv10.3.1.tar.gz"
  sha256 "ba48d3080d31ba6ae8b6461a96f6f68c9fd2a7c16a0c298cb138c599d8f8c665"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58924eea66ed7e312a9ba6387a344398d25cb8d1259ccd9607328305491c2291"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc265fd90e4d2b1c8fa0954fd60fd58ff2e03e70cc2289a38de6cae2f770dda2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35ca0d979462d9e3ebe90cc915a862ec494235a5ae44a62b96d72537ac9bc562"
    sha256 cellar: :any_skip_relocation, sonoma:         "28f359c498fa7a775799c916e450d8f368ef6c6901a3203d18b6f9370c92af76"
    sha256 cellar: :any_skip_relocation, ventura:        "e9368637af130394b4647b653ee45ce6d909555a0eacc9dc865512ab0b1a8dcf"
    sha256 cellar: :any_skip_relocation, monterey:       "5d33bbb9ad61b4873b75470ac683a197c5ef4ea9635c2fce79375661dfe1d40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5433622f887808a84a7441e2583896c33784797d671be4e89f2b34c0f8db472d"
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
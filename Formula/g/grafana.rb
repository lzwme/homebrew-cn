class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https:grafana.com"
  url "https:github.comgrafanagrafanaarchiverefstagsv11.1.0.tar.gz"
  sha256 "b219cd9670c4d723a6135f317f1ed8dd86262aa25cad9aea1ddcc6830209e7fb"
  license "AGPL-3.0-only"
  head "https:github.comgrafanagrafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13910f94278ae43f02379a6fccd67832e2754c4cda58653db882984939090c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc300c8f9acd97b04ff9ae9c2b038641f3b663b351f815393214a3004dd78d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a53cdf3dc036513d110f94f1ad9b4aa015c680f4e1f3f9965c92b5983e055a98"
    sha256 cellar: :any_skip_relocation, sonoma:         "ced7df476e9f750d53d30c7eb2870a98b33cbafbc790623203d61899e989f51e"
    sha256 cellar: :any_skip_relocation, ventura:        "e2709d420ecd9e81b8022e498986ab98cf1ecd498ca812a284b3ffb571042883"
    sha256 cellar: :any_skip_relocation, monterey:       "64cb90336cba20939a2bedc167d47b7f1684ec6040c31a2b2caad0b3b40a1178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c53f793eab6d5a213cd6ac6a2465c741119bc6e49f08c7f25e0da7a5197e3f0"
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
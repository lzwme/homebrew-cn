class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghproxy.com/https://github.com/grafana/grafana/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "d322ef0260cf9b3761805cf7888bf5f163be9bc339175d3503b666c1c50aeea3"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34dfc18d78773c5cd947bc92bc6f37cf6e47a764f7fa41e4ffe9650da5579471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b92fe66f9bdd48418b3df04345ab8a204fd9e43f681d42ee821ed73215c1bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f42ec4141da3f49ba1b34c8825e149e10462c3948b4702d956d4f8bcffa447f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4bfadb7193c110c49c03cc6a80ea75a0b528434ca6e7441140bf9552edabf0b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e6ec95347f6da70d62a002e36011e9f4a46855253c76e27acc764b2a49aa590c"
    sha256 cellar: :any_skip_relocation, big_sur:        "20b0c59224080131ade58dd21d7b9c139a0903f933d8e9d378597499c79e612d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86a339b827dd8ef203740ed1d514f7f05d910d0a62b1c0baf8a1c53e7a1b3e1c"
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
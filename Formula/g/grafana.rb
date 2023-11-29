class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghproxy.com/https://github.com/grafana/grafana/archive/refs/tags/v10.2.2.tar.gz"
  sha256 "2e5e785163667e1ccb2b717b58b9a1b51c1ee1dfe570cb68c613b7e5c0d9d22b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53736c528f42b6caa23cb6215e3521fb8f7569fd05b5bd7b60ae81c8d7e33e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b378a0285296738699a1ce5cdc5f324d34de65e0d61ea429af3ba2004b6cbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "140d0cd144eea2250ce0be341ca298a1cbd2c18fccb165b83e5138553797ff10"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca1332b960c7d85e1115eb22d9838b0b2a6b518f0550f544e2dabed1cdc75000"
    sha256 cellar: :any_skip_relocation, ventura:        "3d9c9b457c8fc30f7fb9c5ab6456920526652088bf4267abb81789110e0d8fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4c739244d43f3b7b32b29dc13ac8c9f7ff725c7fb425da6e1d798aaf07ae0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f37f051d0f00e2c6c16805a5d65a942342887da3a3b8c023f6365419fda177b"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build # TODO: Update node once https://github.com/grafana/grafana/pull/76097 is in release
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
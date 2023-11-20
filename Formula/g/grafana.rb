class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://ghproxy.com/https://github.com/grafana/grafana/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "66bc6141e322f5f73db9c10d7bd44b108b823d7b7e9b4e7b0eeed308aaaa92c2"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f494b9216c8a866fcd533724233114911f239087421f378ff589896ab51d20eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6976c8cd96675bc2ce959ad5c8f1a12568c7510bc43cb798088d248c88c66d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfc49297c6dc780b9daee236af2c9f38d15ba569a486be3c10e4bf35af39db74"
    sha256 cellar: :any_skip_relocation, sonoma:         "213860761209d1e7c43174506d036364c8d3b331c48652a83d75d6ebdce26fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "7b6d36adb0dd024cda18cb26191186bf77f8c4d5c17f420e918830ea4b2146cf"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb132146ddc13a7cb7994f6f307f26cbfccd1e3f111a33d93475f7b847c7c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63eda0d3cb28a5fb9ef95ff5412fe01a9258a804492c04d320be4cf8906147aa"
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
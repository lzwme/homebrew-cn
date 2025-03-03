class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.59.0.tar.gz"
  sha256 "48163a93dc9a1409274172235f9c4b591cb1809b9874ecfbf0bee34d90d3fd89"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5389117ffb60604afec3db1ca7121d06a5d8973d1baededc8b1f4d29192210"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30317c2468c8fae3d55698c6006642c0df0b02c1d16fdc3855de73dc72cc5c13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5def347418e9f420f9cc5c4342c5cea94db8b5620e093b9081c18ab93302a09e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a04755fcf371ae20f5a6597e6a1538c9e7444230adbd7e9e7bf06aea8781dd"
    sha256 cellar: :any_skip_relocation, ventura:       "588756d987ec3531ba11e07d53caa496e3070eb3971be75d2c6eae54960e96b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0056c0ef08d96d3eb36828a28ce336deb90b103150e17541dd7d2a02c14aa95d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags:), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags:), ".cmdautobrrctl"
  end

  def post_install
    (var"autobrr").mkpath
  end

  service do
    run [opt_bin"autobrr", "--config", var"autobrr"]
    keep_alive true
    log_path var"logautobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}autobrrctl version")

    port = free_port

    (testpath"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin"autobrr", "--config", "#{testpath}"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http:127.0.0.1:#{port}apihealthzliveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
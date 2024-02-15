class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.38.0.tar.gz"
  sha256 "32807de4c833b8eb9fafca235b1ef354f847a34a4870fa6550bb007ff7505fbd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4889097def785c555c8e5beef4ae4d815783f3818b9b73b3c5e9da557c4e8d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab2419796998573330c1fa75951c6112d94e19cc04c5135b242a2e109dd16cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9096d3ebb863570c1fa6b7e3fd3b512de21633322c2fc3d2233e10c4c8b85bbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f975e771fc31672d758a7fe59512ca436d4f59e86272ef2b74f9229860956ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "6e90772dfec1b7302e83b25e5b588e856f3e655b90c4685764b4ef448eb17737"
    sha256 cellar: :any_skip_relocation, monterey:       "1533cb388e07c256c94152016a27c5b9eb6b203d00684ce7d95640d193c83c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c50b3732266c1cfc5deba638899c5ea7d36d58c94efa741fa9576e23574acd"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npx", "pnpm", "install", "--dir", "web"
    system "npx", "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags: ldflags), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags: ldflags), ".cmdautobrrctl"
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

    (testpath"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}autobrr", "--config", "#{testpath}"
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
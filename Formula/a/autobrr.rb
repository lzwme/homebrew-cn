class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "40339265b28b9e79f6849ff0b4d97a8d73e6d0c27fb3052984dceb0415abad16"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44ad322bfa245fc919c62b40cafcdae25fecf0307438285af193d0d21f1217c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b010051a4d4d9db24a5ff057c23bbbc38b46e212c6607db78057ccbf7e983e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23ac6a9a13e20c4f041eb1726a6910f0807696072e3a3ae151b5c7f6136f03db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2324077d5499655f44dc73dee94386ef23d60c8abf799bada6f33c5b3b529956"
    sha256 cellar: :any_skip_relocation, ventura:       "e4f37477d21d82c92648b4712d8a54123450828feb473fbe3c118173a53d7003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8970d652535afded432996cbc47a6ba61e054ec734e11b617a8df831a2153c01"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
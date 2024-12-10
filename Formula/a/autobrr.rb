class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.53.0.tar.gz"
  sha256 "216957bb6a968e5c72d30a7306dec4ce1e0f2cf7f58dc2a5f0380ffbba2127fe"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b54489ee7ac33189f65f3131be53d7ef2d5c2606d88f1ad569ab78a6e6b92ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b54489ee7ac33189f65f3131be53d7ef2d5c2606d88f1ad569ab78a6e6b92ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b54489ee7ac33189f65f3131be53d7ef2d5c2606d88f1ad569ab78a6e6b92ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b97b18ffec3eeeffd139b8884e688ca4592c51f63d407852abcd1f10fca7b85"
    sha256 cellar: :any_skip_relocation, ventura:       "8b97b18ffec3eeeffd139b8884e688ca4592c51f63d407852abcd1f10fca7b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a97d21812d7822b53375a8e89ee41fb607f648ccacff07c6b5bedfac373315"
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
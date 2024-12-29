class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.56.1.tar.gz"
  sha256 "1bbb65003f34a94cfbaa8f7a460d045e3d6537a2597188196682c040b62cf053"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e1649b226838b114aae4ad8186eacbbd0755b894d16a0d21cb6c832884e761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e1649b226838b114aae4ad8186eacbbd0755b894d16a0d21cb6c832884e761"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1e1649b226838b114aae4ad8186eacbbd0755b894d16a0d21cb6c832884e761"
    sha256 cellar: :any_skip_relocation, sonoma:        "233bed65aa8cfaa6f47b18ca0b2fd902de9ecd73d5963bb8793c2fb93b0df296"
    sha256 cellar: :any_skip_relocation, ventura:       "233bed65aa8cfaa6f47b18ca0b2fd902de9ecd73d5963bb8793c2fb93b0df296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a1d8e2cbb18c822fca7c470aee39b420727c95ff9368643cbfaa925593168b"
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
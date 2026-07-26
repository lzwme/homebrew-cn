class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://ghfast.top/https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.15.0.tar.gz"
  sha256 "859410f71f03bee5fb0f4e1befd248151d93a51842cf27412c967145510c83c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "44f54c1094ab634f250dc95382f7ecbad46eb1584e28530c5ca30e1981c02f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e3c6bdb1841c27528564a3cb3b63230e755433389d492a7e58a12d04827774e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on :linux

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build:js"
    system "npm", "run", "build:css"
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/joshuar/go-hass-agent/config.AppVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"go-hass-agent")
  end

  service do
    run [opt_bin/"go-hass-agent", "run"]
    keep_alive true
    working_dir var
    log_path var/"log/go-hass-agent.log"
    error_log_path var/"log/go-hass-agent.log"
  end

  test do
    # test UI load, primarily
    port = free_port
    hostname = "127.0.0.1"
    addr = "http://#{hostname}:#{port}"
    pid = spawn bin/"go-hass-agent", "run", "--server-port=#{port}", "--server-hostname=#{hostname}"
    sleep 3
    assert_match "Register", shell_output("curl #{addr}/register")
  ensure
    Process.kill("TERM", pid)
  end
end
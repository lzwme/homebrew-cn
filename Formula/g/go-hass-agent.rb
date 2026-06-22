class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://ghfast.top/https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.14.0.tar.gz"
  sha256 "03a9879303e1375d5cd2364230d3007539b9f16fbeba6ec28001cc2b5201ef4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6c3bbdcae4cf75bd6b5b5aa44cd46cbc5c08673947404092966f7f75df4b86a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "096767ba3df777260d9356bcbdd1bdd734eeefe6e1cb2803f5e0e4b3a6c714ae"
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
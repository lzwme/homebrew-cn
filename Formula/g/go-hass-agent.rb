class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://ghfast.top/https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.17.0.tar.gz"
  sha256 "8506161fb719b948ab026c2533bd43b03659d0ac490f6b343fa2b4591f62696c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b28eae8c787e0e89d297d555383f9eec39d40a1e77295aa26e93ca559a9d096b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "981b282602145a4931447afbe4aae46d8baaeef32db427b82c35106040d03ebf"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on :linux

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build:js"
    system "npm", "run", "build:css"
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[-X github.com/joshuar/go-hass-agent/config.AppVersion=#{version}]
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
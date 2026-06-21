class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://ghfast.top/https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.13.0.tar.gz"
  sha256 "69187938f760241d82338898218dce9da3d5062a32c1fcb6a5880d9e62dfeff9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a31f472a368498ffe4a52037a32994b8c30200fe23c4dd99f8eaadc86bd36805"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00a1f73a6f56f9ae8740908842c44b790afe28191e31973080ab5c2992b3a6e2"
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
class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https:kamal-deploy.org"
  url "https:github.combasecampkamal-proxyarchiverefstagsv0.6.0.tar.gz"
  sha256 "16e8c729ab053cb7b6e01ac6ffccaa0f8a5ee995e57350f027013b28b83e0d78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b21a5fc3c123497ee13a47dfb44db0250af1565a2cd46145ef19ddf52309397b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21a5fc3c123497ee13a47dfb44db0250af1565a2cd46145ef19ddf52309397b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b21a5fc3c123497ee13a47dfb44db0250af1565a2cd46145ef19ddf52309397b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c1a96d14036184c027aad019798a90a0f0e70a5e40a5c48d567d12036e99ed"
    sha256 cellar: :any_skip_relocation, ventura:       "e6c1a96d14036184c027aad019798a90a0f0e70a5e40a5c48d567d12036e99ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "205faef28e9b2136459ff8e5bfc3c3241d79fee2bdfdbb186e5bbe6eb3cb34cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdkamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http:localhost:#{port} > devnull 2>&1"
    sleep 2

    output = read.gets
    assert_match "No previous state to restore", output
    output = read.gets
    assert_match "Server started", output
    output = read.gets
    assert_match "user_agent\":\"HOMEBREW", output
  ensure
    Process.kill("HUP", pid)
  end
end
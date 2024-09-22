class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https:kamal-deploy.org"
  url "https:github.combasecampkamal-proxyarchiverefstagsv0.4.0.tar.gz"
  sha256 "c622e6dcfa2c0728407d4ff9ce663484da3e025a2089e498a61950163fac656d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fd5398d267e295d9d042b360f366b0328fa18d9942e8ac4cdf9182536b73ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83fd5398d267e295d9d042b360f366b0328fa18d9942e8ac4cdf9182536b73ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83fd5398d267e295d9d042b360f366b0328fa18d9942e8ac4cdf9182536b73ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9de9c2ca1eff2e4377a472e168af94ee96a59970377378e5891db8a5694eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "de9de9c2ca1eff2e4377a472e168af94ee96a59970377378e5891db8a5694eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b6d6b281f7863ea592e5df30fe66acbe8bb075f1b890783836133a3563f422"
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
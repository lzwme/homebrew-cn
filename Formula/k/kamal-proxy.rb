class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https:kamal-deploy.org"
  url "https:github.combasecampkamal-proxyarchiverefstagsv0.8.5.tar.gz"
  sha256 "c0f752afa9b86de71d82a0f6471ecc12a3eb67997d1a9b391e28fbeca585bd07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc2c7e16f83442d302295decd0045e25fe52bc87dab60693e4e5a4002476682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc2c7e16f83442d302295decd0045e25fe52bc87dab60693e4e5a4002476682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbc2c7e16f83442d302295decd0045e25fe52bc87dab60693e4e5a4002476682"
    sha256 cellar: :any_skip_relocation, sonoma:        "9732419ab4c700ef845e08a335cdc7b7283e51e5359f1430fe9aeb315b44c91e"
    sha256 cellar: :any_skip_relocation, ventura:       "9732419ab4c700ef845e08a335cdc7b7283e51e5359f1430fe9aeb315b44c91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c08b6e3e4e4a8279dfba37665cb9d9a1a5e02af3a87489897d9a01ec4c1a114"
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
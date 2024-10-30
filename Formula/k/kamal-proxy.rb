class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https:kamal-deploy.org"
  url "https:github.combasecampkamal-proxyarchiverefstagsv0.8.2.tar.gz"
  sha256 "dcb6ba86a0eb8771884f4bad110b3ac28334516c05cf02e52e70dd1434fa0cad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f2299580f86be5dfbbe42f9181a8330191d6092672e4d2f4aa86227264c4ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f2299580f86be5dfbbe42f9181a8330191d6092672e4d2f4aa86227264c4ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27f2299580f86be5dfbbe42f9181a8330191d6092672e4d2f4aa86227264c4ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ef7b193be5835f13c2c3abd144fdcbf4179d4cf41da38c26f3652610bb262a"
    sha256 cellar: :any_skip_relocation, ventura:       "42ef7b193be5835f13c2c3abd144fdcbf4179d4cf41da38c26f3652610bb262a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb885d5b0167d06fa67b8b67231eecdcc6f42ae8d8dc4d1890c80fb2d7550b5"
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
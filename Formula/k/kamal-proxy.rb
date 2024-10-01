class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https:kamal-deploy.org"
  url "https:github.combasecampkamal-proxyarchiverefstagsv0.7.0.tar.gz"
  sha256 "33047ee7e7d50f12662cc63b0a0c9e7d1f8792986da6b12b0336e1cdd2cccee5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3bd904d5845af3ae71a864c33338db25ef69518eafecb3e945a0579b8ee8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3bd904d5845af3ae71a864c33338db25ef69518eafecb3e945a0579b8ee8bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e3bd904d5845af3ae71a864c33338db25ef69518eafecb3e945a0579b8ee8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "10fc46d9a77fe98a1d356b5b4668a112930d3697a6d4f38d980cf862dd039c50"
    sha256 cellar: :any_skip_relocation, ventura:       "10fc46d9a77fe98a1d356b5b4668a112930d3697a6d4f38d980cf862dd039c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec45260b2ce5799a47903b8a51cd049113c251422158b6faf36743991fb38b24"
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
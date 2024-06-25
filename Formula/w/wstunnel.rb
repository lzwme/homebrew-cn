class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.7.1.tar.gz"
  sha256 "c623e5ee46569795b5bad9186ab070b9d6e5b8c267c4631c6289af23b8d57e77"
  license "BSD-3-Clause"
  head "https:github.comerebewstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207c8cdcd5a0e49088f3d4687b82f5efffbcbb728510e654acecab498a33d432"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9460f4c9fbd77f78cd8d46dcfbfc2bb50c59fe6928c6690399ac2aff84b0ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9597ecc3903623fee7d4a2dfc48bab10cd306f308a8cce0f5ab80a9bd56483d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d49956d4084db738bcbe15a1d3e33e50dab9d52e915f78fb7a867688b700878"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5339bc21e4a836feafe479e07395fccade25530f2e2e42a1e842eec0bbec35"
    sha256 cellar: :any_skip_relocation, monterey:       "0015bdacf958b9328c8d497154cb0f0313338e3619a6ef14e23c21a1c5676c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3eba6357ffa8be5676dd3a9726b548634edbf0952aedc330d6456c2a40ff3ec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin"wstunnel", "server", "ws:[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
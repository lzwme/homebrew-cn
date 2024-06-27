class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.7.2.tar.gz"
  sha256 "9493d4e08dea82b7ed07db800c5e7438ac3410cf1add4d18955cd46dbb0f87ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3661846792199642005e6fb4d0afb3a257ab229a2e99544d835aa4a251e55e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c12e4e1d9505b456e48812f679e6fa5209bcd0562c3fb88441442543b8561fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce1fdf7b43e1e7ee720026dcb38bf2777bc22c6f5665fff8f612b2e82469dfef"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58c93f056d81dc12b7c63a1ddbba67f5228cebafaf51bdcdd6c589269fc6139"
    sha256 cellar: :any_skip_relocation, ventura:        "e83a44ffbaceccbe67f42946a8e0f44080a32f4a97074081ad8d8743ef1d03ca"
    sha256 cellar: :any_skip_relocation, monterey:       "70bd96fb405d493b27f17183d5ad3b8ca1289eee2c99b217070b7d37d743ff15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa46a7412d638558d82e387214bbb2f6647a04a4aee6e252a6a8c86156c733d"
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
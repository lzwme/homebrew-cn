class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.2.0.tar.gz"
  sha256 "e5b29465c447c110e4f7d2c1e99a9e6e883f2ddaf6373459d1008607811e637d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37087a7c1dfe67b61fe2d91c10aa6ef203bc2cf16dc726fcaa6dcc28c0e4a282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28ebaec804efedd2d0ea729524ecdce4b224b594575740907b2d97cb60213bd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad3eaaf6382533c30f1d8ae528a9d13dec05433321e5d237d920e8f661de738d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cce15bbc4f38d5294eab53411cad2acfb9914d850e1e1a9fe3d6c13ad66eb09"
    sha256 cellar: :any_skip_relocation, ventura:       "dce50becdc45bb17dad79eec62a6e61d65b9b779e097a43a7d1ea843d8be807a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4f49da0e0675859eb7fe252f9b8e0fa17225d28a6e12accd6677aeee7efacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f71fe635fb3472976cb60580cf7ffd7ad8a9e162089840246addca6411beb80"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
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
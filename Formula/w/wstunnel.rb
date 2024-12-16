class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.8.tar.gz"
  sha256 "45ba8b334701f831c3d9f3db1fdf5de5fb019dc102dcac151cd3d72076862dbf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a1c9d495b08197ba06badfabf8f75752b0875a039d9271d0d0d52ca1a22067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf05de82a31a33c70e9278282333c0c00ee5c3459fa2cec72b7ec5d642cc903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "213fa87e2d238275f455e691be38612658a737d9954d413ba424c9b28e187962"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d577a7cfcfda7a195e89aebf3ca3160eab10d89a384a9b35686992cb9d93b4"
    sha256 cellar: :any_skip_relocation, ventura:       "4d713c6ba48180a465b00a55b6a50dfbb14c962c3191467117d58b5470a85ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6aaa2e6d04f48db83db3419f03e672ba0f71dc399bb00e72e12d3e513e4e180"
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
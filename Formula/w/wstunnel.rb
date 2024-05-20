class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.5.0.tar.gz"
  sha256 "15e83929af29e44d4be1b9e13f38d3420d1681fdfe900409607d56579a1ceee1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe747e5b52edad02aecace1f9335a855821e19c86b5dae3cdd07a6155e42e111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b824fcf5a59ec238c7ce953358bc5a3eb1d4355586628eb524a1a81894273fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c0dea903130cde853e8e4cc3bab0d1abc14274d491c0c34c03d4de3f288c19"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0c0e16065de422e90b961feb78d9a86125a42f0cb3d8a9f205cca0b73e3114a"
    sha256 cellar: :any_skip_relocation, ventura:        "eea498e20a9c828f71bfeec4ed3f5fe8e90b71ef69c131370eb10fe0b9b6b3f2"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4fb9e3f5f3d6be889034fd2e1d8b1a3be9f579129edc2e5aa083469a51f2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144c21713e1486d431253d4d2efd916c5d27a1a9b0849276e04acfd354dcb481"
  end

  depends_on "rust" => :build

  # patch version info, upstream pr ref, https:github.comerebewstunnelpull276
  patch do
    url "https:github.comerebewstunnelcommit4f1ab5c8cb7c32048e380c3ce35e817e2df82f85.patch?full_index=1"
    sha256 "fdd5fea55f244239b21f22a14b841c404158ca24884fd74ae7675161601137a4"
  end

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
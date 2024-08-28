class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.0.tar.gz"
  sha256 "44da14d6fa7bd5d168b0563f5a6447f0a18956da9ff1692a1409def068fda87b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d7555a05fb9af8624618c88bcd913a208a437906b19a0cff2b806a597d2fe11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee024f439791302330f9dc5dc5218fe1a801c576a638a61f7e2d09cf80f4e79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f7e17fdbfa68e038df3a3126016041c6ed05c1a67cc5b051e8dfcadd4d19c3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "93c47645ee7dcb6228c4bad3595fb6089ae416a3c5c1d14ad9c6ec8f10fee02b"
    sha256 cellar: :any_skip_relocation, ventura:        "05967eb21521103a74d42b785787f8111fcc8be167a2cc7330a20ad982c25f0f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab60674fc17ec2bb3b1447aec0bf47ce78f47f697c4fa8fea39cc3c0b73806e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5f5adb828eab541134ac40ee3c7f01dcd7554808b12cfa9a6c3b01468771d0"
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
class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.2.tar.gz"
  sha256 "0879c11664cdc77e2e1fa7d43a76f77193cdc2802e52f2ca2281c367699375f0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa48cc35425dfa95e1dca46c2d480f0de7661af459d13152787242b9148937f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0837f23962edd17abecb4550331a4d3a1183f67a91ab802430a263cc79ffe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d22bf7f6a0b037f80b9fd9ac423a79ce3b653f97b21f137dc31eaba0e3ac1b7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3596d4f1631aa451443bef8c3e3699067b3e4e58e2fbda6d74e02ce0e0858014"
    sha256 cellar: :any_skip_relocation, ventura:       "6d2964d189c261e7479345ef2bfadde6b34d63a34523a5baa671e8930203bd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f72ccdc6ace316f0f71abdbb6114edd3b1d682e159bbd2032becdff6283c8154"
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
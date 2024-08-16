class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.0.0.tar.gz"
  sha256 "4ad729c23c3339d5699f7f137deaa1263d4098537daa716b28ff26f130a5b7e4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f1d7ce844b0c0d47bdcc6485df0cb8459625ffe2c85725fdefc560313897f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41fb6b251179489c5dc9c2be8d99330410b1c724abe106fb4c6cb8ea959c1478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a26e143456ade4ac4f649cc7d1024118d8c25a23687c51a2a87e73fba70d4d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "58d47f6bc76553cd70d3a2f8001ee34b8647179e112d5690c0e1269fda39dd32"
    sha256 cellar: :any_skip_relocation, ventura:        "1b89a2194046251b18800ff449f80c2ae4dded93141eae75701670a4798645ef"
    sha256 cellar: :any_skip_relocation, monterey:       "eb871656e79f6c1dfffa94d13c5b1dc2e04a322ddf04f798957f18ee42a90848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad35a627a0a5f9c21410a7e4ccfcc8fafea90879bef2965a14ae147e30d4c3b3"
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
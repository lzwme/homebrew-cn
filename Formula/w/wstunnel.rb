class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://ghfast.top/https://github.com/erebe/wstunnel/archive/refs/tags/v10.6.0.tar.gz"
  sha256 "15504114bd2a275dde16999d075b17e7d84989b1c54e07dc0c91574d113752e2"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44a7b386332a863467ba14ead1a95a749072df031a259f07212114eb563c5db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37a930548f64b57765fb1985211b182b787ba559c96247f4bccf116fabbc7431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffc573d937ff83d8ff37b8afda701ea3aca00cc6b640b1fedb4a24db9e86605"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a282c4219c4f7377dc0e09d70a48ca7992b5270d971af3fd3e1f26fe53574f"
    sha256 cellar: :any,                 arm64_linux:   "0c48e04919ca627872a9b782e73708d4bcdb7a9499fb808b709cc5d96ee723fe"
    sha256 cellar: :any,                 x86_64_linux:  "7c8a0f950f7fbd973b80dcf3ff57313288886b20b17b1fa7abb62971f8250cf9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
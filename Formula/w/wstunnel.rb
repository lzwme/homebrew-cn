class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.7.tar.gz"
  sha256 "7cc11681f77eb50331133299174150ede929edacf381bb06ab762053770ba03b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa44a98c86926822a10d001c800d21e59a789b46541d8129406ea3b7ea2c4f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a741a9126aa476984910b95c6ec60ac92d695e582a6ab5340d896978dd610ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28c994aa29ef322db0f7fbcc0a8b27d893cf097534451b56ee899bef91ba1806"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bee9d63755f1b12826e605ec0978fb479a4e3d4bcc6b60478ee4bca6a2bc59b"
    sha256 cellar: :any_skip_relocation, ventura:       "4a623a8d8e760154e6f594e6d371c544a2b903d631e617647f804ff37326156d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9eafa049a00ec21710be5f43918728e9663538cb2281824d194b91e86e51dad"
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
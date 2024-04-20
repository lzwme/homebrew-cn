class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.3.0.tar.gz"
  sha256 "bf812d144949acab53b6aef256c3474577b8b0448db0f2307d2c6c5248fbe1ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e97dbf81b789224f898dc3367b4ee32fce614ba7795b8953450c55051725d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1c4ffa1724ebda6454a8191b3ac36b55c8bf7e22082df6ed91485dadd98d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50dea2801310df9ff6190d514b755eb3095d22a2c11a2d16b20c823f4c889ac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0c9ed92009b0ee26240c451f16e92fbee31613576f3580f36e7d6692dc608e"
    sha256 cellar: :any_skip_relocation, ventura:        "5724ec808f9c43493e83a6103b12b86c179ddcb57c8da20386291cb0004431be"
    sha256 cellar: :any_skip_relocation, monterey:       "315c87b5ce14561e8451d2d61c541fd0154013f4d708817891818185b697e9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cf31af17fbe4557b53db5a7a8c4dd7c2ed0e2573caf9253f34d8f3ef65f06c"
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
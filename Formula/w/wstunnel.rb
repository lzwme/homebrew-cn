class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.1.tar.gz"
  sha256 "c29a28c855792122a24da4bc109d348e3b5f42167c1e16af24bfc4d796d6c8b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db75f799f0481290e47bc00e69619e3625636931b4cf155c541d4b43d7ab6ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57bce84d5222373d8acb793a7efa4a30b55e9fe72d467765a841a53b4821abef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c72d5a909d357a4ce17558b9205fddc78e93fbc2ba362b345f1eadfdc81dd31"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e181d482fa1568d47d2f8d5212925a081771739b3baee6b069f94d839653f03"
    sha256 cellar: :any_skip_relocation, ventura:        "869a86080559a4b79ee210d8268a555a948994396ac48d250fa4ea89c90e9ba1"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b6c998b637e3a67b2fc6cb810a2127ec11a32b9d49316613381f4ed2040105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0423e3000f75e2d5fc3e017a1aa52fad03723fe614855b66aa0090030cfe0df2"
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
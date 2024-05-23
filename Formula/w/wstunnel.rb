class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.5.2.tar.gz"
  sha256 "58bb7c82f9a5e13504215a74885c5d41a53bf15fb9c0c8c7c806e9184857ff6f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "debd9cc456dcaeeeb9e5a6acb6dedf0521c74ceea4b3a0ef5c4ff221bafa8b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2d94568f511f03047d1eaaccece3eec43e168bea8eb95d30e926b6ae3d4b5bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb13f1340713ba3851613e9821c76f2e9f252df66e3a7f698455c1852a8956f"
    sha256 cellar: :any_skip_relocation, sonoma:         "189685473765788023fa68ed54d19027e5edaf7258bffe888f2638ab3ea2e3d7"
    sha256 cellar: :any_skip_relocation, ventura:        "22a247fb5f3bfcca2e681ea95c6debdd05339d3fd36ee66353935501398c2f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "5351c7584cf249257d87fd166bbd3c2f3a518fb52f81ae38a1e026edc3d02be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e1dcd4d82b3348a58daaacc95b56f36446caa7eaf8974418a1e25853095d7e"
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
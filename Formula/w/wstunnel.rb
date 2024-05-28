class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.6.1.tar.gz"
  sha256 "f7c48fb1f37c6ec2f969814c36ebd73aaec305a1ab2da1c5b9bd658479bd06c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d83f0a12579164811931632a415fa065ea31119b350381ca2101ab1f696e7890"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b39344b18c94261a25aa1ae25ad5ff4172a8e8d1fc4aae88429be7c3bd9af5cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcdec03199465bbf6b11e17dd804d2d0062090fa5a1fbdcd2f3e40cf00f40c0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "753b7540ec50ce7aa9416c976d4fa007fb03eddf8dfca451330777f2cff2f845"
    sha256 cellar: :any_skip_relocation, ventura:        "c3acf0aedc695187cbeef5382f8198bc9fc519d34026330a6f6d2801adade829"
    sha256 cellar: :any_skip_relocation, monterey:       "b23fe0d6c186bf21524c9aadca39b346b6ab559f89db02f48699339e1e16db07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9ac95c957ace93e37c904956990e83a8835a65658c53d99dd651907ccbe2f0"
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
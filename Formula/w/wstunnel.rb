class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.4.1.tar.gz"
  sha256 "976e8132cf4ed120d8db4b2304f500408938ab857ad025b6fbe7f60d4d306ab0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420460cccb586de6d8080d5240eadea74fb442704723956b8638c33ac52a1f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d406f25402505952da03aa532c2887f7427a680b398051b6609bdc887fe628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "833a1873fa502e72576c2211ea4c79ecc2366042bd3ecc49152f235d0c2b242d"
    sha256 cellar: :any_skip_relocation, sonoma:        "448e4b6a9bb5eedb9c828c5567b3e4b298d065d4c8aeb5303248a703df83039f"
    sha256 cellar: :any_skip_relocation, ventura:       "8e9294c4089c6d09aa090df41fd0b21e145120bcb14380282d633070c311df30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f84742a848f520ce7ffd397b2103bb58f034929feb181517e8e72423c0e0fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef176dc59831d1d1d1535b090698ffc2a645c475852c91f7de0bd802c73f06a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
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
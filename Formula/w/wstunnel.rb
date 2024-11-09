class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.6.tar.gz"
  sha256 "c89b0fe2d7848233304e622c7ad744954ed4b287edbec48d8e2d65a2569dbd3e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676a83ec2468c0850038ab2caeceb9e6ca7a2a1756432219f250f4b5273a434b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616288b4a14ffb2204a8104ebfc319e8862b3f098a19c80a21b06035475bb618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d17418db2d5102d0831f630b4f5d73660a6cfb1e41d140308c7b535c286ccaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f0ae0fb94d66e1a9c517d66175208e9df100f8af0227c918ea94c33cd9ed285"
    sha256 cellar: :any_skip_relocation, ventura:       "92f5b818409be3c62f1d6cbec770e373b6abd89ea1e2f7ad8ee64f08fece9b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df36664a9ac4721df27bdf1a2ce1363a6c15952ba9dfb4d5530c393d75151365"
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
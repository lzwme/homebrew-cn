class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.5.1.tar.gz"
  sha256 "6451fe1cf4c7f9f6a990cea447359d4d2fee92e434d414edd48dc8345786efb2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "277f969b6bf31a11c9fd87f05c76b0596218c9adf43ecb869e4bb8ec03fd74a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22181733ce5551af09ea0ac480826fb9e074b080e7df0fbd0ad02b701141d32b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77f5a7305a8590c187f5f394d117e32edd9f7e505f796a8d66a4b5e5c85a4b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfaf9123824a47660c38884ff0aee7cd98f6a71a35a8f5b9d7cb878522754642"
    sha256 cellar: :any_skip_relocation, ventura:        "158afffec5a54b802456c0db0dad277ab81093d4ce2d60c5fe1c6bd4232b717f"
    sha256 cellar: :any_skip_relocation, monterey:       "efc6d557a99f49585df5142144d9a581d935166e0aa1b3a5ab4a24e9ab2e15c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86863ffd0768c5547d9da548502f38dcc2b05484dade828d0805964294e4ca47"
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
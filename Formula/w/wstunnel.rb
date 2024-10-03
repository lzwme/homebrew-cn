class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv10.1.3.tar.gz"
  sha256 "528659f1d0f9e8e5f2ca02875919b3d5ea89db6ff300ef7cef39d994d0a2db4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b247d0b98f0a8f400185759a4a5c655238caa44ce2cb40f9b114835fc0ac7344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64394806f154b68eb86d20892f7b7ff79f2dd47eed5ab7052f1488af3be92184"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f0410b3910f536fd05d53d75bb8f297dae5b4184d64bffdca4b651b8144d7d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be458252dc3c7d213c107dd51d6c2ed674aacd9245df3649ce03c08ff1b8df61"
    sha256 cellar: :any_skip_relocation, ventura:       "42120def87a44bedd1b82e4c6ac1ab232f884122f71e7ebe3b16529b04780c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1796658d9e2ff2e49f5ddfee4242707c9c051ced4bf481443b7b11d210db40b4"
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
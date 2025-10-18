class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "2278c6d96312c72781fb52fc08ec653b5fa56cfbe957348b899df8de2e8703f4"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2e9571c98d9867821a059d82e210ffb8e18fba2e60e86c6d3d71e503ec3b604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e778d9672b8358b734e5dc396d8945d6c44a02b97afea6138e396238ad8d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f308e9dad5dcfe2a3f9202f84757d83e0dfd3b1b1aa2001ded7add3f2f3fe7df"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ce44b3d86a81f74774be73692f9b19520ff470e8e562fabc0d0a12917466b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca80ecce41f4162225a1659eaea550520ba96eefc908c6d0c4e8fcf162a2a033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b051f52c8c7c525264d5c3c41f214ff81c687cd6dd413722754391e3769c6bc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
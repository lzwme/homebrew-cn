class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "b82f2a146864f1c5617ec59e84a676b83587d99622264b8fa2ba8ab448cf4e3e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad20060cfa0acc5a41efc92b28c8ba6d3f14a8e79082aafa7a6fd10a22c68453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75cd5835108f6ac057d7bd6bb3717ce2f5842daff61d7d3cd16144250b80a4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf7cc4eedf5468b064aa46218ffc55eba31e24e59222da78b6bc25f008b5c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "d180bbe945764def936ce27aba0a37e11df2ecef3c71e3ef82f6c86f90ee0263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86abda28bd96c0960ced69ac37d2eb3f585a68bd05995cecb20e1e33e90a04c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13720dcf2cbe0faa12bccd6b64f6d898c00af7790abe930a77bc6110260468e7"
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
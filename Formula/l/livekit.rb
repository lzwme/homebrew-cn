class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekitarchiverefstagsv1.8.0.tar.gz"
  sha256 "18003008a5523d7c20655ffc4c2627ead05e8b2ef409b97e23dea67a8bc3ba76"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91539ca2ec3cdcf3e8adfe30c80cbe5f99db42d8765c50fbf91ccb964515bf61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e2d1630e4856fb481b52a890a77c5650ba138684ccf4a585766d3dce445323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9a4bd73c70d9f02813029d0d9970637ec7d9f35348fc69b91915017b98eb1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5509f79d2fb948be58852c3dab88153a03bda67311b063565c8b9277cd2d09"
    sha256 cellar: :any_skip_relocation, ventura:       "99675ff972d242f8e1e6610f9b069896e0b0e06290ec9f55603df5653189b9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c076548160a94ff09ed19df067a608c37202b75118a9fa87d1827cc6eaa6804"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"livekit-server"), ".cmdserver"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http:localhost:#{http_port}")

    output = shell_output("#{bin}livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
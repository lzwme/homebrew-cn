class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "cfecff4cefda989434c8302dc1f2075d3171194559dfe50e47e34f5072796518"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e0578be6a294927a870357db9baf00c9f9cf5fb0e7c3303e4fee2db6ccf4a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a8b4e46d7b06e4f45563151799362408f45356444bfb2fe6dfcb288b25a725c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "089c24c63ab8d45505b804cd4bfeaa87ec130f0694714be7474964ec4b3ff9c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9001d3c4e0cc3c18da992d8f192a2095b509b501edc1722d23e9434cbb1e7ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63785f5d583838e142854ebca5b13c704868cfeeab96f92f56b388bb67e837af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9feca8f26cae0dd323d9f874d6d8549ccda9de65369302162aef2e153abbb270"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    spawn bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
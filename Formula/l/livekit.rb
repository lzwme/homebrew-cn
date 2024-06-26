class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekitarchiverefstagsv1.7.0.tar.gz"
  sha256 "238b26704c16ce2446e1e4978f60ff0dfd5b5b080d6648e491236cec2eb7524f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e62af6c3e41febcc350375ce0c86ba268cf939b54aef8fee532b565b5f01818"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "609a57466621e9f68010944bff9d41f31b73de0e393196bd746ce0d4c320a92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf11a2476ae0b863fedf8388b430597fbc72937e418f57b4b3cc710f13d3dbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3897121b84f1e682fdf74ba3cbe4f5ff109eaf21f6e3b09c929f51659268328d"
    sha256 cellar: :any_skip_relocation, ventura:        "3b1d41bc742805ec0560bf37b7dcaf190cb099e3a015371a02f5ee8409b547f4"
    sha256 cellar: :any_skip_relocation, monterey:       "eef744fa5fee538313b8266c97ed1c4c474fa3f576571b11a9342e93e0c98847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5221447160ae51ba260485a1b042521077cd87b5b8bdf2354478500f3feb49c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"livekit-server"), ".cmdserver"
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
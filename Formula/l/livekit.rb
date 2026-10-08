class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "6e5977d4fa61b52257a576257e2da1fe5e710eaf0b66d94233f4653d4f760920"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bb4fd5092648c2f5449df0635c94e764176ae0516cbdd5f1b1668ffc8271059"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "187222af8a72c8d4c7c00134650a7c1d68b44be77d9078d6487a6f17f1cf1be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f3b5b443bdc30e35c0956c4bfd8226594a57703268ce1926826c0f1eaec0205"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a2331433e52eddddb2046c5dcbe5edfca74ad0885b425df2ea752bcc4b1b9cd"
    sha256 cellar: :any,                 x86_64_linux:      "89bb0b7352c74880bfa629db53cad7a8b1a0636762d2f7e018fc280e9d7dd283"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
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
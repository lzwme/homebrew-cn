class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "76d56a0b9dc27c48a6b14ff3559251ad902b68dd873253e85f972e9dea25affe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21ed751e3bea4b891406dac6bfb66fdd4bdbc975b94f20e50ee0caed50d11056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd5292f2b0bb81ab969269d3f0fe04f63f635abfcadd9e09340908291588b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38c701b17410dcd5503010014db6fe8ca0b1afbe6e48c86b3a831d1789a7272"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced2bd793d1d81d8e27a39853800dee0db0baac78ed86251a8b9d4d5f337e055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868d1c73f57fa774850618bc1a3423997a7f208a58a4320b05ecafdc7cb05fac"
    sha256 cellar: :any,                 x86_64_linux:  "7f3dd443308f71b9967712733e0ee8b9a0ed199229d1f57e621763a09c4fce18"
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
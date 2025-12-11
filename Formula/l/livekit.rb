class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "db128f4ae291150d7a0881bf2388acc7d9ab71f8ed3e1913d034ef71c83ad667"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ced7d7c05da22f06fb835fdf1cd3288caf6d79ec855b190ed81daed6a136ba2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10ebc6ba0a05a5a469440d67ca05a0319e572254cc6106ccdd9cdf53e944047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5aee8faae75404175d0b8ecc20ffa9a47ade60bf615eb8431ee33805511735"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa4919dbe8609390f903df2dd14f6e7dfcefe3dcd3a27842547abfbee5c39aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ea64855c1eb82dce4fbd4e01373e00cf7727178137fe5a87c88bbcf73d48ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c36f039a3d787ae05bf0c879983f73e257596d2969dae1bda9c56b00f316cd7"
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
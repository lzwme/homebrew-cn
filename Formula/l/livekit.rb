class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "281a234753b284db58f2ccf1528f80f0895991ae6ff3d0e78d154881bdf26bb0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed1f9b5852df77abd07a2faf7ca56729b11b140746c73d87c202824ae7c17f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a33ae058b118fba904ae5013e7d5b7cb0668b1975f5c47da833c6e837a438982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a03e7c027e23d41d97908916c5a6a0bb307a023ccdc694b7f15b57367dc86426"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2fb3db158adffb70c45acb6271cfcb429268600d76ff828a3f70a1e88336d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd096ec97a161f543a458a7cbd1ce14c4b4e7628a13b6782bec8addccf28e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49fd05fc38cf71054948ab4af98b48264e311b16f11749e00cd824ef239a585e"
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
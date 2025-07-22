class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://ghfast.top/https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "09120a2766f862be9a6f71631e5b8112cc995ecfa2f41a95bc2796ca5d1e67d5"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1d8e47002fcd2a4c96715e723a8c5be80b1a01ad2567c47e9925242ab03e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8967ee6aebef60367f806d2c98083c1a6c4b7aaa4afe26a4939650c4104e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a79af1d536cf1f9343c0c6ab537519c6a94662fe0ed9349e4cc0476d728f419b"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c88e74aa26d83e0c8545b0222b5b23b5dd878b6c7d52f7f6c2fe164c1cb943"
    sha256 cellar: :any_skip_relocation, ventura:       "fe0389a94ebaa53f2fb8ad6286edf288f14603425703c4145c6756a36bc33d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4afe1e86d86c73539a1ea3352ea47a4d0c01b544ccb3422aa67a025cb7a9b2e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/v2/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/v2/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/v2/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/v2/info.BuiltBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc/"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin/"gateway-go", "-c", etc/"gateway-go.yaml"]
    keep_alive true
    error_log_path var/"log/gateway-go.log"
    log_path var/"log/gateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_path_exists testpath/"gateway.yml"
  end
end
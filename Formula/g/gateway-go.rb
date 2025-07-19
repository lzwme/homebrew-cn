class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://ghfast.top/https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "692edd4fbce3cb1969291f534d4fd8008f4162f19224cf9c15ac50558f8d84d2"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94eae1dbcde508c0a4fd473be80c646d98f394fdd6512ff2faab2a84f8e4985b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08dcc754a746832a3088b626a441385cc720088f15ca3a57017476f428d4f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e222d2cc649f9d5e233d990aa8000d2b44b4fcef68aea560e05bee0bae66e5c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc344c75092c511340c072e4526a6693ff8a2bdbbb91444661c94815339f8aa"
    sha256 cellar: :any_skip_relocation, ventura:       "cb84d234e189d3d90c6e7b8c805016317f4685ec9af83ef9a403f59c5b8e689f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a4ebb47314d5ad28ab23c172968269c2364693c0888a619f7b9d493ddf2f9e"
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
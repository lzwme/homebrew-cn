class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://ghfast.top/https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "95de453e76a22ae69a1bc9c32d6930278980c98decbe7a511fd9870bcdf90d2d"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d06cbb839faa56f60c458fd9ee81afb0e75ac44425f853946dc64b77737945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd65ff9636a19d7be1cd6b534854139bf20c3af802f9040f3db7eb4489e1ba37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d99f14fbe19bd62caa64279d419da8b27c73f9f6f0170ff4a89d712541ac8d0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "188243613be33e1a759747819d64647503b64be51dd2f1ff56840e8b761109cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f31c311bbc54ada41596d6807f7ad9080519e0a83a76d4360cbaf2f31efe3150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6c9fb22790a50284a796b6ca7a2bb9231dca4fa6b1fb01e30dd1027bc11b04"
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
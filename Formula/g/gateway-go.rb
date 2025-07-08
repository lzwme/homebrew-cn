class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://ghfast.top/https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "aa2ed249c81604d9b6192392a8c55afa015cf5ef94052434bb76b78d3e796937"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38be8dcfac5ea81b46787c91307f720ad508500257b29022383bf7b8f9c5b285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9a8f49e438959bbf61536ac60bf288312a0e53f447302dec857a3c7fc35699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "725e070b6784fd65781a6756554d11491c6628a71abc3da0d6af85aa7809332f"
    sha256 cellar: :any_skip_relocation, sonoma:        "038284c2270ab5fcb46feddd4e8f8d055e012ed0c9e8e620ee4458863f5e4d7e"
    sha256 cellar: :any_skip_relocation, ventura:       "649d1db6812e2f17ba5a77df3064041790fe0908d7fd1dd6dbdf0c4d747b604c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476cd1e1953c52a04ac721f6adeb85d8c81355382dbcc8181777c84e2065a224"
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
class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.1.tar.gz"
  sha256 "31e4ce40bf7e3a9c0ab16cc8c588ed773f83dc3dfb8f88cd23094187a66d9539"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "628f2fb4580ad75c9c2e23a7f2ac9b4f20fbfc68c17b77554790633b31a15cfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "628f2fb4580ad75c9c2e23a7f2ac9b4f20fbfc68c17b77554790633b31a15cfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "628f2fb4580ad75c9c2e23a7f2ac9b4f20fbfc68c17b77554790633b31a15cfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e32ec16b52b408700b2619d7507fdfc70c75a5ebc87c0dbdba6edb092fdf19ec"
    sha256 cellar: :any_skip_relocation, ventura:        "e32ec16b52b408700b2619d7507fdfc70c75a5ebc87c0dbdba6edb092fdf19ec"
    sha256 cellar: :any_skip_relocation, monterey:       "e32ec16b52b408700b2619d7507fdfc70c75a5ebc87c0dbdba6edb092fdf19ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edd998c2a18f4f896845c42be239756f062e3e442394492b14986d5ccb4bc2a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin"gateway-go", "-c", etc"gateway-go.yaml"]
    keep_alive true
    error_log_path var"loggateway-go.log"
    log_path var"loggateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}gateway-go init --config=gateway.yml 2>&1")
    assert_predicate testpath"gateway.yml", :exist?
  end
end
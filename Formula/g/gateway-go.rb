class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.16.tar.gz"
  sha256 "82dfbce4fd34829e57bbd88f57f560daa975521cff930bd984182b03d423ecf9"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbc68900e42b2e6135f3bd8ae33cef531e30e50dbf56bff75a2ce08939006752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97bce27f464e748e5e4640fbea21b3b16fb2294ce36b0082d62603019a0f2a14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b553ebd879ad2e827f70366eb4b4ebe3357bda6a539ed3f3e6b8df012d45d079"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6490c994c0dc7fc0f14212673f6d23ecdba4d66afbe1ed19b703e968f76df3c"
    sha256 cellar: :any_skip_relocation, ventura:       "ce4a91ededd18a4f1287fec96f85110ecb35e13ffd29cc7fe0142dff16913da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ac4d15be0a40d146c42110fb5233fb31e595de1d91f2ecefc242b6a754d320"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comOpenIoTHubgateway-goinfo.Version=#{version}
      -X github.comOpenIoTHubgateway-goinfo.Commit=
      -X github.comOpenIoTHubgateway-goinfo.Date=#{Time.now.iso8601}
      -X github.comOpenIoTHubgateway-goinfo.BuiltBy=homebrew
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
    assert_path_exists testpath"gateway.yml"
  end
end
class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.15.tar.gz"
  sha256 "2d1beaa96177ce23a71c16ee3e915ea4e767aa8b07843a2486d900997ab44403"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da125ae38a25bafba031e6efc1d13c8efd2d2d8c958b011a5329586b2061ccbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8e93a37c54f171729515dd460f4acdd5ea267efd833cfc5c9c8611ff3b7e09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "675c52e8c3d9d3903b6ab9842ccd30ff1e8ba840d054f82813e33b8499f1847c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b33210dc8316bcfa8f0015385dce229017289d15521a74f00a94436205504f2"
    sha256 cellar: :any_skip_relocation, ventura:       "083bc16521597f627048a11bb21270a357a8f14807e43826e785a4c5160ab5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ea7ec8301e9c6102a67c6816e2bb5d4fcbbd511c7833585c19f0739559196c"
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
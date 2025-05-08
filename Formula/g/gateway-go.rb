class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.21.tar.gz"
  sha256 "2a42bd1cbc06ddad40ce7048541e046ec85ef6f16129bce077061fb4f77edb4e"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bfefa307853bae03a8da16a8621bcdd466f008b6debd1fccfdb9fe8f1a5b3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70808a40170e41243e7bf3eca285f46807aeb101d2f155cd9aad2ec767f17310"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4b31f26ee084290b3077d552bbabf3836fbe357c8379b49bedb5083f3b324a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "88dac9b78749ace8b7b4eb42702f3b82a4f7fdc8a510c52222ddd31180a11361"
    sha256 cellar: :any_skip_relocation, ventura:       "ad3fe02b16b1ce7b9ecb38779edde651bd978a8c3df3f856753fe5e46d88e27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a35ec30cf33b8cbb6c3dfdb5e4aa7ba6659b22e221a7cedef676b01425542f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comOpenIoTHubgateway-goinfo.Version=#{version}
      -X github.comOpenIoTHubgateway-goinfo.Commit=
      -X github.comOpenIoTHubgateway-goinfo.Date=#{Time.now.iso8601}
      -X github.comOpenIoTHubgateway-goinfo.BuiltBy=#{tap.user}
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
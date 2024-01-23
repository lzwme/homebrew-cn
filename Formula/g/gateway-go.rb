class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.2.4.tar.gz"
  sha256 "fc0cacaf0b64da767d3119ecf4ac4a7b7a5e05150306a1cdbf0222d4b6d20028"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b00930a3fd95993c394719edf3417e1316524b98241b03c248566c8a515fcd70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0188d1c6a7bd66ce1e3ffe631c7806fcd7cf8caf23d22689ac0a49dd5c348b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d765efb4a8d176c3f2982e6911b97063b0661e50f930eaf4a007bb9e8d7a5c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbefe4a08af43df27c26cf234425e3554a3c21465c7214110f09f36bb8d843c6"
    sha256 cellar: :any_skip_relocation, ventura:        "1c91660516510681c9d5825633b6e4eb204f71b5b403a9e155fec727613c8ee6"
    sha256 cellar: :any_skip_relocation, monterey:       "76e80151a68401a737e729883fd41c895b7fa782c21526d9bde29df2ddf4c314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd5ff76a98d8fc24809758cd56475482c2418f9e09c242e4e5e8ed4e64908f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
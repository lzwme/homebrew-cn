class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.2.6.tar.gz"
  sha256 "016e68baa0c0e309b8e2162d19349a30d4172fd2a71f4a63491fd989bab46271"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8085a4e836bb03cb5a76eec2c4e26931160c45d8cba6b2560b88296822e09bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10dbfc0b6043ac708aa31382741c098d70b68c462a97669b795dd7558834efce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095b3c34ee7e8ba7c7959db5896bda26c38a2d3721d5ffb7cb7f421e0664536c"
    sha256 cellar: :any_skip_relocation, sonoma:         "945c4bb073b23e6fb0c1dd621213028704f4b1fa2f00d4837d3393bb51443944"
    sha256 cellar: :any_skip_relocation, ventura:        "49c4600e286cad748f6e0fb7ddbcbd2740d63df16f4df033885dfd5045edcf82"
    sha256 cellar: :any_skip_relocation, monterey:       "b8114751ae26f99508257329e859883c1e974cbb0e9581dceb45b5307a3f9fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673f0a11917d2b72915efae85ce757baec3b336de4a856ae9a5f5e0f19905735"
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
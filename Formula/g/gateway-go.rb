class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.2.3.tar.gz"
  sha256 "18b4dbedfc9fd626e7ca88626d45e9d0db637c3468191e343939392633bf56a3"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f19973fc7331811977cf6203da6d75d6ca553e172b33b6067cbb35be2ab5751"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0bf84743ed63dc4fe5c06c0743cc4355dc12038f06af251c91d390ced52827f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4f098f92044dc790b081041401df026c95f08c0ce0ee27d233885eb88676ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5b7340840fc2ff1b01689fe96b7f901aa30d2a0ac8a18e45923a7899bb7d326"
    sha256 cellar: :any_skip_relocation, ventura:        "fe24211398d58a048f6f0ecaa8ab5ce57f22b09ccc2dc37ebd0af14d050e3ed8"
    sha256 cellar: :any_skip_relocation, monterey:       "ee263b2412c526479e28dc35abc3c7c5c34ad51f1942150e87e37614c7a58a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bd523d8d9dfe7adbb3838f308810511e045dd8c8ef77963ae2ab36beb0277e"
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
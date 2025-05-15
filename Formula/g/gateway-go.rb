class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https:github.comOpenIoTHub"
  url "https:github.comOpenIoTHubgateway-goarchiverefstagsv0.3.22.tar.gz"
  sha256 "0f5569c95f0ec1c825d29d6ee80b25da46b30ce8e5b94af6f3290d89135ccd0f"
  license "MIT"
  head "https:github.comOpenIoTHubgateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff717cd8a42548855426de3772c534caf55727e6826496a6eec0e1f5c522df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49898c4d166e854f8c944a281dcedd1a664164e6125de67bebc3e74da624da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cd5d6a7c2cb47e0943910c6719f808691ed31dc46433564bf9642d7e621ece2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3cd3a2009f13ac4cfea324615caca3b66be3f807e8d121993209ae64cd6343"
    sha256 cellar: :any_skip_relocation, ventura:       "dc71cae0f6fe7cfb9e7863759fe5247ab5ac754d30887b3fc2971248fb7632db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2a5fb9d71b936cc4a1b4db7cbf6ea04ded3d9b031a9953b10f6123edcbf6b1"
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
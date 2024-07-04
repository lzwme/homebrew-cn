class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.12.tar.gz"
  sha256 "1e4960fa1ea3bfa11100f0f797159f852e93f2918d189b06cc1a429d75348c8c"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b89697ce0ca38850d9b08b4dbf631d5d438f478dd18f9c1b31780d0cb271e0c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9eebfc80c89bf71ec6ff0ac3183833183b7fb222e510ef040e69520647b7680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa46130bf83e3d2d61f255a842a92c0bbb82640caec1402c52fd62156547ef8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "25f594357178633f321939370a27d8d963b4a49b59fcba2f004991018b4939df"
    sha256 cellar: :any_skip_relocation, ventura:        "d2ed350364391ccccfe6b733dd8c21c27294851de855e9c1c35ac881186e24ba"
    sha256 cellar: :any_skip_relocation, monterey:       "329f39388a0792707bd8598fc892e7a49af54560d209b9b9df510456d3c1f37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c959aec4aa89d98022e51bacfa3c7a6602feb39c5e1b55e9509072db9f68bbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkubescapekubescapev3corecautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubescape", "completion")
  end

  test do
    manifest = "https:raw.githubusercontent.comGoogleCloudPlatformmicroservices-demomainreleasekubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}kubescape version")
  end
end
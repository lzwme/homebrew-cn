class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.22.tar.gz"
  sha256 "49d21cd87b6c9c88c06639e93619accdc9b99c4a8e872860d8045f7a919b5210"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d114fbfa7087ec1c08389e43b41b346aac39c3ebf431fcd6650cb71f2fb4f9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f772194ac5011e49e13a73440436a2a1ffae26b8e0af313a5204b5397b6c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "348e3cd6430aeff98a4455fb0148e192bda9e87bd038cb3fae9adfe44b31fe0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "70c61be1a868a3fef39e4a43a42c656d1a58eaa01615e9b1a2e35e765c028e8c"
    sha256 cellar: :any_skip_relocation, ventura:       "41de07dc4559ec5089d77292675879874bd145a34e17165ed533c6549459600a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51d4f85890322e03eb7b113ce5c61cedd1bb14a53a234b467e9112e95b58d5a"
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
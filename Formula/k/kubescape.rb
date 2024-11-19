class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.20.tar.gz"
  sha256 "a293dddd1223e568d4d23a43c4d8eb69e61ac15b981ff084545af2a0c7596d92"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d6a7437a2c52f1dd7cda19ddebd244da407e6645393abeba7fe0d0fc62c88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bea21bce3664608d8c23fa3b4f0a59890ef2aace112f0d43da95942dc10c45e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "109988f816c506ad872adab1c9aa331bb5fd96daca5aff31e05df7eb23642d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "4712113e51c2a55fd3a4d47f6ed896aceae69f24c8b3ccd67484acd3dfabff35"
    sha256 cellar: :any_skip_relocation, ventura:       "e13156cded98b0235c51154056fb311597ffd25e0b9c1e1c19c0b0e3728ae5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fd68850b456180bb9032593300fd521588ab150b74794185b8c5854484cf62"
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
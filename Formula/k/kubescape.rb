class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.30.tar.gz"
  sha256 "faff6a9dad090ac033ea4d58a5eda89e2afea4fe1e4c402f82723e019562ba39"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd5472f26a006136a7e62234772f5ce4b831de297a2f2896721829d9e0b6bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e4a169729926933b50b4ca0d888fe9b4b1bf02114c01a58d256db12d7daf97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a4c6adc0671b95e2c18d2aeb5ff360c9bed3cd8d937de547dc66fd0757625b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13c81f0b8649117cba6c57e2972df54400cb410f5332872db7f2fe87518f11d"
    sha256 cellar: :any_skip_relocation, ventura:       "36d2a02299359611f4db5dd3ed4aebe8ac0fdb10d52667a49b8efc9d150e1e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ecf7c35b2cb3b92062bb5c9c76dd3fe910964c516eda49201ded90fd7869609"
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
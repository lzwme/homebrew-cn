class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.19.tar.gz"
  sha256 "d62ee82027f142ae002e09924cbbd0662c0a5d07b07f6579517c7ecbc8d23655"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db0af197e6bc247be0c8a6b2d35e736473ef06f856fcf91fbd76036d3dd5d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a072d655711d1411d934a24ba7fa1c6eeff85a74b2fbea1ac91f48de4ea1d034"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3234778fde34a53893e14d9559d662f75b23868e53fe4c7fc910d35e0139509"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e2ae3a8ce14b32d3f86208a168c861791a118ad3d9a9606d41bb5bc3ce14c5"
    sha256 cellar: :any_skip_relocation, ventura:       "dc7cd39f8a257e039ef14468329de7bd1ae4caac6280389cb197f579c14c195d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28901e7d40089a3a5c485ea9c0c9e73b4700a74f1db4b0629c869484b95ab009"
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
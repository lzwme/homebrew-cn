class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.33.tar.gz"
  sha256 "f08818dc57422eeb9c1d65510b3b2f87cf606c32b42ccb1ff07f2ae49e872940"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f08711a9f2c94a08ebef31ddb4ddaa9e010baf278e9f2d4da46b8e76e58b77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc9c879303b530b40002fe43c7994e48c92de044b394751c921e8ca8046839ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6fdf17217e835c8985560be1be279b3f15546653af6405087fda060985c64cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2398f05027d6bac7a6377df96d93393533508f90be5637e9d0eed51e3a23a7"
    sha256 cellar: :any_skip_relocation, ventura:       "95c765255dd4cb5e5105dca35c36f6a868d29a6d350534a286013b8e13db0141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8842b6eaa696a130a223030cb2f90acc7f5226d52f6b014a9e4351b3225b2a3"
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
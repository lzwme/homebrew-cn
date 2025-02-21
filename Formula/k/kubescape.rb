class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.29.tar.gz"
  sha256 "48fd1db413128bcd6aa34ccba624f6a55642d17be69db5242e113317b9e56cec"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bd911a48dbaf32d5c0c3b5d89036c352bac6b7f87423f69b2d5f011b48c74d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd05d06ea93b9fd1ac3f00b43dcddf32fd75811f541fe92d50f6032655110901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e23a374b699cc5205511d1a42960c39d1624628ff847bc7b2fca00a9986102b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0babb035cc09fe102cb4450e47aa781258288f1a39945f37f48d43e4bab387"
    sha256 cellar: :any_skip_relocation, ventura:       "02d3e1387bf51415f744f59180d6d93ee9d98d81cf159762187247c77770df34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338548a0e830adced750427afcc2328e545300ab49907d42038dfb7e0ba13864"
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
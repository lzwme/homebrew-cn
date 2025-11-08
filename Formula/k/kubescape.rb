class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.44.tar.gz"
  sha256 "f39d9cc43f0fc77ff990e9d44957761b992e38176f57073e44260cb1414dccc4"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c9c262b61e131d60483e7f8829efb93917d03075b1b662c18e123816f5ddae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56142397726b2d01dcc57619d8e14ad93e8d9e2aec89d9927cbe887490016558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7795fa4a3bc7cbe3cee6eb3d9bae22721a3ee8bd8bf5a3db48dcdbc9eebb44ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "81388adc8985a5c4c9aac4459f6368c2eacfcd527497f7e04598cfe12b3f71e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4942b938eb153025e0769e164db2b87f1ec6bf9821203fffacac22e68914301e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd7c91899d9fc1568df0810a5581f512b615bf12f77e61d5fde5f85a2ad150a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.46.tar.gz"
  sha256 "751576f0044d22f8561f26bd76a2aed6f68eb3152d6f81fb1e5c1a303b238a5b"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52337d70d335a4af5461e00b0ca774a77e76ee9216f4c85b62c97b3568505ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eb2764d27457404f6ea37fb3ac97fd83b519e1ca7941ab5832afd271dfd981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483b2c42134e810988250c1884a88184af8da567125fb03b8d53da54b791e840"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ff30e82458dac4dc4d1928ca6a0fe32d3ef0e6e7b8a0f5d628c01f11b8d802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c6500d0faf90721d2540ab148f44b8fa66b5c521daf4de96c4f34fee501212f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5474bb0717c50501654f2a2e06743ea751acd8c4edaebdbe323f6efb2a233dea"
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
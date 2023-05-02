class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "96b6b68b4478300acd2c2f90fb948f8a161e504249d2db356b8ce578c797207b"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "900206c87164e45e2fb114b5519d59252e116f3d69fffcbe773a8618e4f89109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9003a3118aa4363e33097682258ddc6bb436a67f9720a5b847ce4f61f3863e99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34bdedfb0874a20602d76d9d9da36882253ab452394811c9afd24b72683112e5"
    sha256 cellar: :any_skip_relocation, ventura:        "7d509ea78779044c6e6111bd203c7bf27ebc33acd5f9a4c8427f713a48485ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "7a23f7ac998946201ed7aace65d90df5fe07809075ab2e0cb7684f320e0ffbd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1fd9bf0813b928a8e129fad443e333906839c0750eae8d10e570b455307f50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414be3504badbdd85c3b2f013225308f95add33a8655615c74426015947b62c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghproxy.com/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
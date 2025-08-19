class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.38.tar.gz"
  sha256 "d183f683b8f2d620e7736f1b42eed918936ccc86cf9c7524a8f9cc41ef695ac9"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bd2c9381e402755121220e781a27d8376813194f640633969115b913f6e6e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff218df9f2216bc5110f1309e18fbd3b8a875069fe404ee4f81557b238fbd67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecc44c350e5068b33ceb5d56c3c960c466ac9dbb3c3cc2e484601fb2072b9ee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d549456d08289ea9951bef04622ce0c39738fd9c157abb01c57bf538b0a7bddb"
    sha256 cellar: :any_skip_relocation, ventura:       "af69683ae6660a57590fff460713565ceba6e96a64fb447b2ab91178091c3f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694b03bd669dad7412ce5fe4bafd2faba5464be37c45c7edba79664a1a1ef773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeab6a1d1f90d06f268fc1571701390900e0ac38a4f7f1548fdfc8a4a6f5733e"
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
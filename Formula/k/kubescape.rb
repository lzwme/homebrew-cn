class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.36.tar.gz"
  sha256 "11c48d8788993d0aa9e745753e663ac6a92ba1c421094e82520965ea75545ef0"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ceb731ce7670513474f68f94435bdeeca9bf85fcce1f5f491dda42e82d87aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c7411d027bc84f712e573d5c9c669ecb2d8e5248bd73a8347b46eec84af7c66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "921aa42ac087a6f3cd348838f5f687059bc796f60a5704603f0959902ee8ac0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f511ab74750943405b1fad01a6ebb1904f2d947ff30192c39a550f6469eed2"
    sha256 cellar: :any_skip_relocation, ventura:       "aef43ba56a9db1bad98a41ec4ad32f4aad03a31ee0a8852a3f52c9960c0c9595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af802efc17578e7f533cc298e46ca99682bdc7b2fb1327531d746f87be02bfa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34a7de25783a33edc10ac9007b8fb3f9ff67464a723f60cca603593063cc8b0"
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
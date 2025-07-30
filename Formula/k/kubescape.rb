class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.37.tar.gz"
  sha256 "9da14e426fa0c43255d23a4221a9b07c61bfa8a1f64962956be962ee5b67c790"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbff85e4839014b4488d73fa76418263fe2e3b81b47cdfc630dc6adca31af973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3188586ae0f3f98988477a8ae339d8f487147e6fce8751bb1e4dc8922b362d61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11ec2bc71c8ff7fa71cf20492b03d7f84b3201f6a1c1f198b2850b186cca6a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2018bd1b81db928d322081db4ba299b33b013a59d6f4514f7ace68d89261c621"
    sha256 cellar: :any_skip_relocation, ventura:       "190c3561d9c416a27a6d1fd7df29c86db9927f3a9cbf5ca04eb4073d66c9d503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86d582a98ab0029060a3eac2da1ec91bdf3d86d1b37dc1141cf5e00a82129dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8958af3a7da0578dc1641a00420d0d06048c84cd56ffc1dc01a187f9cac95e93"
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
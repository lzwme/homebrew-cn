class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.47.tar.gz"
  sha256 "3782a959a87ea9b0f3409f335e87edda54b0f1d7285c1113e5ec220ff998aef3"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c8efae31ff5c90c30b7450069c1c04d14ca8aac7d380fafe66167eb3308fcfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080cf638391911824d14c0741282d423ca99067e97abcd09a4e06fc4d05c8d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fef080c009c116480db5a37fd644cc85c44896af7413372fc8ce53a35cce719"
    sha256 cellar: :any_skip_relocation, sonoma:        "f320caa10f69f0ae7a4d5f13f3442840e5711faf7858256694603cb908ea20c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e756ec986db859d0504543c2ccc5d7ff5cb8d778741587f71ca5b2d5290f971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6366b595cbd0b546d89a0d4dfdbbe12fb1827a5811deed8a2a0bd548adfdd28"
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
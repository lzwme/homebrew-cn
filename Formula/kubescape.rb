class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "5a1c1b9845f80604949257fac2d40d1a3b97e403fc98524e10b11c893f1e0e2e"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9b66e1dbe71d3d5c844aa4b90edec834b3c748fc5c5bd54bad5a49adc84f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f840bca1ef05eef5d19cc269ec11b90d053587b30d3ab34bb7cf4e9e97a0c47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802f335b97f08ea744755a693db7fa1b4c86aed7dd78aa6d62daa633f7d79446"
    sha256 cellar: :any_skip_relocation, ventura:        "a36709f2fcd4f4545f2dd869a2aeaae36a318957512dc3e267a82c3a72d1fed0"
    sha256 cellar: :any_skip_relocation, monterey:       "e87b8c0d1c67909fc93ca20c0e7765afab91535990da36d09a0fcce7dacaff95"
    sha256 cellar: :any_skip_relocation, big_sur:        "85b1f761dad14081f3043944fe577763f57d698b071bec245fd36af928c3a9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddb1d1741eab130456a563f2e5f3d53af04f359da150012780ff517f7e9eb016"
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
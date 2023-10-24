class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d16aba27941dd2a638d552d0376ab05376f8ed4a525ecfbd9bdf499bf4251174"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3754850c0ebff683b27fa75bc125aac8d123777186dcfd2aa73ed3c3dd27a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e690c8a849201696b36082c3f73eff3284166f5264ac242e2901cd86ffed71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054e1b9186e558b3097eec7f9292353a2d7a267d65f780218ed545ab4289aff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c598674883ba4e199c70e96788cf6c1b5f2c94150ee8a0243040b63414f8b91a"
    sha256 cellar: :any_skip_relocation, ventura:        "fce65533c0ac1c64438600e2789c5394e5e6845e663480ba489de97b588a21d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4f85c33717d5e84d677aa995ca731c65b39eac082609f04afc0dc85e540cb5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0850a571317d70692f429431e1959b5c553fc952b73ac1a487a6b5a1d1455992"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghproxy.com/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed Resources", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
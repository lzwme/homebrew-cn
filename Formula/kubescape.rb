class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "541385a91031869a3862f574b1a757261135f0786069b930482eddb6ca560422"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c9d2fba3b0cdbd2d0306635fa84b64798b00b0eb116bb0d2c0e24217fb7b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa456798000a1a494a16d84877a8d7b77ba07f43ca00f17d9e03bfea6a066b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fa23ff2bd4593923ce9cb47d86fb0416f29ed8ea8cf05cdea20a9ef04e697f7"
    sha256 cellar: :any_skip_relocation, ventura:        "107588f8801f35a2d151b48bccac605649562526576a00f0d544e67f48441bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "1405198796e8cde29627bc5decc8bc8fe97a24a6dfc57d5b5fa9056d1c9064e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac060c7e6b803c8fa3ad0dc855ac1d21bf10f9a750972fe3d62aa33133837e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c0be982391156fe11879cc6130058731a899bb5a29554a19a6ea86a4b65c09"
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
class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "330aee70b847a012c5ad20f318e698d31bf9b3a2e7949be87d77a27954fe51cb"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6c6f55bb64bfb332925af60107c7f83ec1f97b8497350db77d0640fb5cc0e96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b96803235554aaf35336aff875ada2b889ff5bd75fd8c8a52bf3508c7058f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b1c8b07d8cce07d2864b2d17116094c7ea7a4e33610e796d1c6a6582edcff28"
    sha256 cellar: :any_skip_relocation, ventura:        "00005d54a779d07796c6c66caa779dc34ed30c58352105e16ef326a6cba39b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc308e49fd15767d959ca2f357f909c89e2747f9af1968c4babdfaf8c96d10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3868d086febe2806e1222ac650fb24c21af9406aac8d8ed73f3dfbad1fec719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d014e55f0dddebca46379f3b9afb1599415e6ebdaaf914210a10c310e8ac0eb"
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
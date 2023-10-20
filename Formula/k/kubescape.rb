class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "63c9052b5e402a471fde909932ee8a660e96262a4256fd472fe3834e793be14c"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb1f9786e1ee14e3708d82f9b158e2839fd1989706d9e6073796615c1705f9ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f07601cd657b4dc6ebe271d163069bdd9f28ceb4801365e57bf1046a34add29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e19376c29f33e905e7ecd4023abb2f662fcde48f4c7b0c4a1781bedaa6c673d"
    sha256 cellar: :any_skip_relocation, sonoma:         "86beaf7eb6a77cde54689a2364a64fca959d48b50d4d8b0209cba3138e76aef6"
    sha256 cellar: :any_skip_relocation, ventura:        "c5f2e35cf3b733d955f9fa87b83fd8f91a67c47fab66adcda78140b8fccea647"
    sha256 cellar: :any_skip_relocation, monterey:       "ac610713e4f0b3738ae788f949f43a51e427b4c143a14dcd54aeb145f4d23e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf571f132b146a44d284c36d50b4df2090b5ea0a8a290f64d129e1959a43a5a"
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
    assert_match "Failed Resources", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
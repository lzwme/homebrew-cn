class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.47.tar.gz"
  sha256 "1d8c4820f341823dc1fc50d575044099dbf5cbfe2a05fc9e12976715efb41ae9"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b46e8475527e5d40b919e3519afa2d8668ae6cca36c15c9f021a6ad2bb560c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27546ff27da864fe1f13c8f1ce3b6b19e022370a08f489cb7f11d60f1d6ddcf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e5cf5c97d7d05b4398c08f906a2d535174bde8dfeef5c719748ceb08c952e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9107219c9f85191e3a4fbf4bc942a4905ace30750b4532811724a39063f4e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32dc28f0d6a50f43b15597ea883e25c185709d42887ac0d26866602bfa0099e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ce05132e8c310885b052c5de0fc3875e52cbab1a5b8fd2441f0abed1a01e97"
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
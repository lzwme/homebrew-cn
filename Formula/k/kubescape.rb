class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.42.tar.gz"
  sha256 "6430de50ffecd5396273dd00941f995ace76533cfe5937630c716e27209dd4be"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb8f4e05d2a70bc088d97c9049b3f0c8285f1903249e13579eb621a757d4e3d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c09b17e4cf08bb7827c85c5df9d937f79b48928ac5ec763135db095d25fc2f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d0dc3672bdaa4dff10163e81866425e33cb585cc3a34607fa457185e8f14e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8026eed3e0c0bd94db6d7bddc328391c66963b587b0d3985e87b844d56513c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc229c9f95fbc9ac24be4976a58b39b4fe79ed99b5356e46c095814492a3463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd0840c2b3f1cb9f1dd5850fcaf96c89990bea757e4f2465a21cca149bd3d4e"
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